module Propagator (Cell(), cell, lift, lift2, write, content) where

import Algebra.Lattice
import Algebra.Lattice.Wide
import Control.Monad
import Data.Foldable
import Data.IORef

appendIORef ∷ IORef [IO ()] → IO () → IO ()
appendIORef ref action = modifyIORef ref (action:)

data Cell a = Cell {
    value    :: IORef (Wide a),
    onUpdate :: IORef [IO ()]
}

cell ∷ Eq a ⇒ IO (Cell a)
cell = Cell <$> newIORef bottom <*> newIORef mempty

writeAuto ∷ Eq a ⇒ Cell a → Wide a → IO ()
writeAuto cell' newVal = do
    let iorVal = value cell'
    let iorUpdate = onUpdate cell'
    currVal <- readIORef iorVal
    when (currVal /= newVal) $ do
        modifyIORef iorVal (\/ newVal)

        ls <- readIORef iorUpdate
        sequenceA_ ls
{-# INLINABLE writeAuto #-}

write ∷ Eq a ⇒ Cell a → a → IO ()
write cell' newVal = writeAuto cell' (pure newVal)
{-# INLINABLE write #-}

content ∷ Cell a → IO (Wide a)
content cell' = do
    let ior = value cell'
    readIORef ior

lift ∷ (Eq a, Eq b) ⇒ (a → b) → Cell a → Cell b → IO ()
lift f fromCell toCell = do
    let iorUpdateFrom = onUpdate fromCell
    appendIORef iorUpdateFrom $ do
        conFrom <- content fromCell
        when (conFrom /= bottom) $ do
            writeAuto toCell (f <$> conFrom)

lift2 ∷ (Eq a, Eq b, Eq c) ⇒ (a → b → c) → Cell a → Cell b → Cell c → IO ()
lift2 f fromCell1 fromCell2 toCell = do
    let iorUpdateFrom1 = onUpdate fromCell1
    let iorUpdateFrom2 = onUpdate fromCell2
    let updateFn = do
            conFrom1 <- content fromCell1
            conFrom2 <- content fromCell2
            when (conFrom1 /= bottom && conFrom2 /= bottom) $ do
                writeAuto toCell (f <$> conFrom1 <*> conFrom2)
    appendIORef iorUpdateFrom1 updateFn
    appendIORef iorUpdateFrom2 updateFn
{-# INLINABLE lift2 #-}
