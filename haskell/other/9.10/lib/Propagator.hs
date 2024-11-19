{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wwarn -Wno-type-defaults #-}

module Propagator where

-- import Data.Char
-- import Control.Concurrent.MVar
import Control.Monad
import Data.Foldable
import Data.Maybe
import Data.IORef
-- import Data.Set (Set)
-- import Data.Set qualified as Set

-- import Control.Monad.ST

{-}
-- Bounded join semilattice
class Semilattice a where
    (\/) :: a -> a -> a
    bottom :: a

data SudokuVal = One | Two | Three | Four
    deriving stock (Eq, Ord)

newtype Possibilities = P (Set SudokuVal)

instance Semilattice Possibilities where
    P p \/ P q = P (Set.intersection p q)
    bottom = P (Set.fromList [One, Two, Three, Four])

data Perhaps a = Unknown | Known a | Contradiction

tryWrite :: (Eq a) => a -> Perhaps a -> Perhaps a
tryWrite a p = case p of
    Unknown -> Known a
    Known b -> if a == b then Known b else Contradiction
    Contradiction -> Contradiction
-}

appendIORef :: IORef [IO ()] -> IO () -> IO () 
appendIORef ref action = modifyIORef ref (action:)

data Cell a = Cell {
    name     :: String,
    value    :: IORef (Maybe a),
    onUpdate :: IORef ([IO ()])
}

-- add update function should append

cell ∷ String → IO (Cell a)
cell name' = do
    val <- newIORef Nothing
    onUpdate <- newIORef []
    pure $ Cell name' val onUpdate

write ∷ (Eq a, Show a) ⇒ Cell a → Maybe a → IO ()
write cell' newVal = do
    let iorVal = value cell'
    let iorUpdate = onUpdate cell'
    let name' = name cell'
    currVal <- readIORef iorVal
    when (currVal == newVal) $ do
        putStrLn $ "AUTO WRITE: Not updating cell " <> name' <> " which has " <> show currVal <> " since it is already the same..."
    when (currVal /= newVal) $ do
        putStrLn $ "AUTO WRITE: Updating cell " <> name' <> " which was " <> show currVal <> " to " <> show newVal <> " since it is different now."
        writeIORef iorVal newVal
        putStrLn $ "AUTO WRITE: Running the updater for cell " <> name'
        ls <- readIORef iorUpdate
        sequenceA_ ls
{-# INLINABLE write #-}

content ∷ Cell a → IO (Maybe a)
content cell' = do
    let ior = value cell'
    readIORef ior

lift ∷ (Eq b, Show a,Show b)⇒ (a → b) → Cell a → Cell b → IO ()
lift f fromCell toCell = do
    let iorUpdateFrom = onUpdate fromCell
    putStrLn $ "LIFT: Adding new update function from cell " <> name fromCell <> " to " <> name toCell
    appendIORef iorUpdateFrom $ do
        putStrLn $ "LIFT: Update function called from cell " <> name fromCell <> " to " <> name toCell
        conFrom <- content fromCell
        when (isNothing conFrom) .
            putStrLn $ "LIFT: Update function will not update cell " <> name toCell <> " from " <> name fromCell <> " (content: " <> show conFrom <> ") because it was Nothing."
        when (isJust conFrom) $ do
            putStrLn $ "LIFT: Update function updating cell " <> name toCell <> " from " <> name fromCell <> " (content: " <> show conFrom <> ") because it was Just."
            write toCell (Just $ f (fromJust conFrom))
            
lift2 ∷ (Eq c, Show a, Show b, Show c) ⇒ (a → b → c) → Cell a → Cell b → Cell c → IO ()
lift2 f fromCell1 fromCell2 toCell = do
    let iorUpdateFrom1 = onUpdate fromCell1
    let iorUpdateFrom2 = onUpdate fromCell2
    let updateFn = do
            putStrLn $ "LIFT2: Update function called from cell " <> name fromCell1 <> " and " <> name fromCell2 <> " to " <> name toCell
            conFrom1 <- content fromCell1
            conFrom2 <- content fromCell2
            when (isJust conFrom1 && isJust conFrom2) $ do
                putStrLn $ "LIFT2: Update function updating from cell " <> name fromCell1 <> " (content: " <> show conFrom1 <> ") and " <> name fromCell2 <> " (content: " <> show conFrom2 <> ") to cell " <> name toCell <> " because both are Just."
                write toCell (Just $ f (fromJust conFrom1) (fromJust conFrom2))
            when (isNothing conFrom1 || isNothing conFrom2) .
                putStrLn $ "LIFT2: Update function not updating from cell " <> name fromCell1 <> " (content: " <> show conFrom1 <> ") and " <> name fromCell2 <> " (content: " <> show conFrom2 <> ") to cell " <> name toCell <> " because one or more are Nothing."
    putStrLn $ "LIFT2: Adding new lifted function from cell " <> name fromCell1 <> " and " <> name fromCell2 <> " to " <> name toCell

    -- Oh! Answer is probably a merge
    appendIORef iorUpdateFrom1 updateFn
    appendIORef iorUpdateFrom2 updateFn
{-# INLINABLE lift2 #-}
