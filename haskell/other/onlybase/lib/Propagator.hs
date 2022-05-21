{-# OPTIONS_GHC -Wwarn -Wno-type-defaults #-}

module Propagator where

-- import Data.Char
-- import Control.Concurrent.MVar
import Control.Monad
import Data.IORef
-- import Data.Set (Set)
-- import qualified Data.Set as Set

-- import Control.Monad.ST

{-}
-- Bounded join semilattice
class Semilattice a where
    (\/) :: a -> a -> a
    bottom :: a

data SudokuVal = One | Two | Three | Four
    deriving (Eq, Ord)

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

data Cell a = Cell {
    value :: IORef (Maybe a),
    onUpdate :: IORef (IO ())
}

cell :: IO (Cell a)
cell = do
    val <- newIORef Nothing
    onUpdate <- newIORef (pure ())
    pure $ Cell val onUpdate

write :: (Eq a, Show a) => Cell a -> Maybe a -> IO ()
write cell' newVal = do
    let iorVal = value cell'
    let iorUpdate = onUpdate cell'
    currVal <- readIORef iorVal
    when (currVal == newVal) $ do
        putStrLn $ "Not updating " <> show currVal <> "..."
    when (currVal /= newVal) $ do
        writeIORef iorVal newVal
        join (readIORef iorUpdate)

content :: Cell a -> IO (Maybe a)
content cell' = do
    let ior = value cell'
    readIORef ior

lift :: (Eq b, Show b)=> (a -> b) -> Cell a -> Cell b -> IO ()
lift f fromCell toCell = do
    let iorUpdateFrom = onUpdate fromCell
    writeIORef iorUpdateFrom $ do
        conFrom <- content fromCell
        write toCell (f <$> conFrom)

lift2 :: (Eq c, Show c) => (a -> b -> c) -> Cell a -> Cell b -> Cell c -> IO ()
lift2 f fromCell1 fromCell2 toCell = do
    let iorUpdateFrom1 = onUpdate fromCell1
    let iorUpdateFrom2 = onUpdate fromCell2
    let updateFn = do
            conFrom1 <- content fromCell1
            conFrom2 <- content fromCell2
            write toCell (f <$> conFrom1 <*> conFrom2)
    writeIORef iorUpdateFrom1 updateFn
    writeIORef iorUpdateFrom2 updateFn
