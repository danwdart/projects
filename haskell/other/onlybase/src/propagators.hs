{-# OPTIONS_GHC -Wwarn -Wno-type-defaults #-}

main :: IO ()
main = pure ()

-- import Data.Char

-- import Control.Monad.ST

-- Bounded join semilattice
{-
class Semilattice a where
    (\/) :: a -> a -> a
    bottom :: a

data SudokuVal = One | Two | Three | Four
    deriving (Eq, Ord)

data Possibilities = P (Set SudokuVal)

instance Semilattice Possibilities where
    P p \/ P q = P (Set.intersection p q)
    bottom = P (Set.fromList [One, Two, Three, Four])
-}

{-}
data Perhaps a = Unknown | Known a | Contradiction

tryWrite :: (Eq a) => a -> Perhaps a -> Perhaps a
tryWrite a p = case p of
    Unknown -> Known a
    Known b -> if a == b then Known b else Contradiction
    Contradiction -> Contradiction

-}

-- data Graph a = [Cell a]

{-
newtype Cell a = Cell a

class (Monad m) => MonadProp m

cell :: MonadProp m => m (Cell a)
cell = undefined

write :: MonadProp m => Cell a -> a -> m ()
write = undefined

content :: MonadProp m => Cell a -> m a
content = undefined

lift :: MonadProp m => (a -> b) -> Cell a -> Cell b -> m ()
lift = undefined

lift2 :: MonadProp m => (a -> b -> c) -> Cell a -> Cell b -> Cell c -> m ()
lift2 = undefined

one :: MonadProp m => m Char
one = do
    input <- cell
    output <- cell
    lift toUpper input output
    write input 'a'
    content output

adderMono :: MonadProp m => m ()
adderMono = do
    inL <- cell
    inR <- cell
    out <- cell
    adder inL inR out
        where
            adder l r o = do
                lift2 (-) l r o
        
adderBi :: MonadProp m => m ()
adderBi = do
    inL <- cell
    inR <- cell
    out <- cell

    adder inL inR out
        where
            adder l r o = do
                lift2 (+) l r o
                lift2 (-) o l r
                lift2 (-) o r l
-}