{-# LANGUAGE DerivingStrategies     #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE UndecidableInstances   #-}
{-# LANGUAGE UnicodeSyntax          #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-redundant-constraints #-}

module Main (main) where

import Data.List.NonEmpty qualified as LNE

main ∷ IO ()
main = pure ()

-- In the Star
--
--
-- dimap :: ((c -> d) -> a) -> (b -> (x, y)) -> Star f a b -> Star f (c -> d) (x, y)

-- BCPFG :: (Profunctor p, Functor f) => (p a b) -> (p c d) -> (p b (f c)) -> (p a (f d))
--
-- BCPF ::  Profunctor p => (p a b) -> (p c d) -> (p b (f c)) -> (p a (f d))
--
-- BCC :: Profunctor p => (p pcd a) -> (p b xy) -> (p a (f b)) -> (p pcd (f xy))

-- backAndForthCurried :: (c -> d -> a) -> (b -> (x, y)) -> (a -> f b) -> (c -> d -> f (x, y))
-- backAndForthCurried = runStar . dimap . Star

{-}
data Indexed i a = Indexed {
    index :: i,
    value :: a
}

class IndexedFunctor i f where
    ifmap :: (a -> b) -> f i a -> f i b -- just have f i as a functor tbh

class IndexedFoldable i t where
    ifoldMap :: Monoid m => (i -> a -> m) -> t (i, a) -> m
    ifoldr :: (i -> a -> b -> b) -> (i, b) -> t (i, a) -> (i, b) -- take this higher?

class IndexedTraversable i t where
    itraverse :: Applicative f => (i -> a -> f b) -> t (i, a) -> f (t (i, b))
    isequenceA :: Applicative f => t (f a) -> f (t a)

class DoubleFunctor f where

class DoubleFoldable t where

class DoubleTraversable t where

class DoubleIndexedFunctor i f where

class DoubleIndexedFoldable i t where

class DoubleIndexedTraversable i t where
-}

-- Class these for "Can be a"
newtype Height a = Height a
    deriving newtype (Eq, Ord, Num)

newtype Width a = Width a
    deriving newtype (Eq, Ord, Num)

data Size2D a = Size2D {
    width  :: Width a,
    height :: Height a
}

newtype CoordX a = CoordX a

newtype CoordY a = CoordY a

data Coordinate2D a = Coordinate2D {
    coordX :: CoordX a,
    coordY :: CoordY a
}

data StaticModTwo = Zero | One

class Zero a where
    zero :: a

instance (Num a) ⇒ Zero a where
    zero = 0

instance Zero StaticModTwo where
    zero = Zero

class One a where
    one :: a

instance (Num a) ⇒ One a where
    one = 1

instance One StaticModTwo where
    one = One

convertListTo2DList ∷ Size2D Int → LNE.NonEmpty entry → LNE.NonEmpty (LNE.NonEmpty entry)
convertListTo2DList = undefined

convert2DListToList ∷ LNE.NonEmpty (LNE.NonEmpty entry) → LNE.NonEmpty entry
convert2DListToList = undefined

convertIndexedListToIndexed2DList ∷ LNE.NonEmpty (Coordinate2D index, entry) → LNE.NonEmpty (CoordY index, LNE.NonEmpty (CoordX index, entry))
convertIndexedListToIndexed2DList = undefined

convertIndexed2DListToIndexedList ∷ LNE.NonEmpty (CoordY index, LNE.NonEmpty (CoordX index, entry)) → LNE.NonEmpty (Coordinate2D index, entry)
convertIndexed2DListToIndexedList = undefined

sizeOf2DList ∷ LNE.NonEmpty (LNE.NonEmpty a) → Size2D Int
sizeOf2DList xs@(y LNE.:| _) = Size2D {
    width = Width $ LNE.length y,
    height = Height $ LNE.length xs
}

class Matrix2D entry matrix | matrix -> entry where
    createDefault :: entry → Size2D Int → matrix
    fromListOfEntries :: Size2D Int → LNE.NonEmpty entry → matrix -- exceptionally, we don't know the dimension yet
    fromListOfEntries dimension entries = from2DListOfEntries (convertListTo2DList dimension entries)
    from2DListOfEntries :: LNE.NonEmpty (LNE.NonEmpty entry) → matrix
    from2DListOfEntries entries = fromListOfEntries (sizeOf2DList entries) (convert2DListToList entries)
    toListOfEntries :: matrix → LNE.NonEmpty entry
    toListOfEntries = convert2DListToList . to2DListOfEntries
    to2DListOfEntries :: matrix → LNE.NonEmpty (LNE.NonEmpty entry)
    to2DListOfEntries matrix = convertListTo2DList (size matrix) (toListOfEntries matrix)
    size :: matrix → Size2D Int
    getEntry :: Coordinate2D Int → matrix → entry

class IndexedMatrix2D index entry matrix | matrix -> entry where
    createDefaultIndexed :: (Zero index, Enum index) ⇒ entry → Size2D index → matrix
    toListOfIndexedEntries :: matrix → LNE.NonEmpty (Coordinate2D index, entry)
    toListOfIndexedEntries = convertIndexed2DListToIndexedList . toListOf2DIndexedEntries
    toListOf2DIndexedEntries :: matrix → LNE.NonEmpty (CoordY index, LNE.NonEmpty (CoordX index, entry))
    toListOf2DIndexedEntries = convertIndexedListToIndexed2DList . toListOfIndexedEntries
    fromListOfIndexedEntries :: LNE.NonEmpty (Coordinate2D index, entry) → matrix
    fromListOfIndexedEntries = fromListOf2DIndexedEntries . convertIndexedListToIndexed2DList
    fromListOf2DIndexedEntries :: LNE.NonEmpty (CoordY index, LNE.NonEmpty (CoordX index, entry)) → matrix
    fromListOf2DIndexedEntries = fromListOfIndexedEntries . convertIndexed2DListToIndexedList
    sizeIndexed :: matrix → Size2D index
    getEntryIndexed :: Coordinate2D index → matrix → entry

newtype MatrixList2D a = MatrixList2D (LNE.NonEmpty (LNE.NonEmpty a))
    deriving stock (Eq, Show)
{-}
instance (Num a, Zero a) ⇒ Matrix2D a (MatrixList2D a) where
    createDefault defVal (Size2D { width = Width width', height = Height height' }) = MatrixList2D .
        LNE.fromList .
        replicate height' .
        LNE.fromList $
        replicate width' defVal
    from2DListOfEntries = undefined
    to2DListOfEntries = undefined
    size = undefined
    getEntry = undefined
-}

newtype MatrixListIndexed2D i a = MatrixListIndexed2D (LNE.NonEmpty (i, LNE.NonEmpty (i, a)))
    deriving stock (Eq, Show)

-- TODO replace the replicate with fmap (const x) [zero..] or something and not need integral here
-- we should be able to use custom datatypes to make default indexeds. So replicate is almost definitely not correct.
-- We should be able to get the "whole lot" - to the point of which we decide. Some enum thing I suppose.
-- fmap (const x) [from..to] where from = zero and to = max (which is )
instance Integral i ⇒ IndexedMatrix2D i a (MatrixListIndexed2D i a) where
    createDefaultIndexed defVal (Size2D { width = Width width', height = Height height' }) = MatrixListIndexed2D .
        LNE.fromList .
        zip [zero..] .
        replicate (fromIntegral height') .
        LNE.fromList .
        zip [zero..] $
        replicate (fromIntegral width') defVal
    toListOfIndexedEntries = undefined
    toListOf2DIndexedEntries = undefined
    fromListOfIndexedEntries = undefined
    fromListOf2DIndexedEntries = undefined
    sizeIndexed = undefined
    getEntryIndexed = undefined

newtype MatrixList a = MatrixList (LNE.NonEmpty a)

newtype MatrixListIndexed i a = MatrixListIndexed (LNE.NonEmpty (i, a))

-- instance (Num entry, Matrix2D entry matrix) => Num matrix where

-- instance (Num entry, IndexedMatrix2D index entry matrix) => Num matrix where

{-
instance Num (MatrixList2D a) where
    Matrix _ + Matrix _ = undefined
    Matrix _ * Matrix _ = undefined
    abs (Matrix _) = undefined
    signum (Matrix _) = undefined
    fromInteger _ = undefined
    negate (Matrix _) = undefined
-}
