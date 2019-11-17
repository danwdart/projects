{-# LANGUAGE FlexibleInstances, GeneralisedNewtypeDeriving, MultiParamTypeClasses #-}

import Control.Comonad
import Control.Comonad.Store
import Data.Functor.Identity

type Pos = (Int, Int)

initialPos :: Pos
initialPos = (0, 0)

newtype Sandpile a = Sandpile { unSandpile :: Store Pos a } deriving (Functor)

instance Comonad Sandpile where
    extract (Sandpile a) = extract a
    duplicate (Sandpile a) = Sandpile $ fmap Sandpile (duplicate a)

-- Only works with numbers atm
instance (Show a) => Show (Sandpile a) where
    show (Sandpile x) = unlines $ fmap (show .fmap (`peek` x)) fullCoords
    
instance ComonadStore Pos Sandpile where
    pos (Sandpile a) = pos a
    peek s (Sandpile a) = peek s a

instance Applicative Sandpile where
    pure a = Sandpile $ store (const a) initialPos
    Sandpile fs <*> Sandpile as = Sandpile $ store f initialPos where
        f pos = peek pos fs $ peek pos as

instance ComonadApply Sandpile

instance (Num a) => Num (Sandpile a) where
    (+) = liftW2 (+)
    (-) = liftW2 (-)
    (*) = liftW2 (*)
    negate = liftW negate
    abs = liftW abs
    signum = liftW signum
    fromInteger = pure . fromInteger

fromListOfLists :: [[a]] -> Sandpile a
fromListOfLists aa = Sandpile $ store f initialPos
    where f (x, y) = aa !! (x + 1) !! (y + 1)

toListOfLists :: Sandpile a -> [[a]]
toListOfLists s = fmap (fmap (`peek` s)) fullCoords

zero :: Sandpile Int
zero = pure 0

allThrees :: Sandpile Int
allThrees = pure 3

neighbours4 :: [Pos]
neighbours4 = [(x, y) | x <- [-1,1], y <- [-1,1]]

fullCoords :: [[Pos]]
fullCoords = [ [(x, y) | y <- [-1..1]] | x <- [-1..1] ]

samplePile :: Sandpile Int
samplePile = fromListOfLists [[1,2,3],[2,3,4],[3,4,5]] 

put :: a -> Sandpile a -> Sandpile a
put item existingSandpile = undefined

puts :: Pos -> a -> Sandpile a -> Sandpile a
puts pos item existingSandpile = undefined

putsl :: (Pos -> Pos) -> a -> Sandpile a -> Sandpile a
putsl modPos item existingSandpile = undefined

modify :: (a -> b) -> Sandpile a -> Sandpile b
modify modifier existingSandpile = undefined

modifys :: Pos -> (a -> b) -> Sandpile a -> Sandpile b
modifys pos modifier existingSandpile = undefined

modifysl :: (Pos -> Pos) -> (a -> b) -> Sandpile a -> Sandpile b
modifysl modPos modVal existingSandpile = undefined

toppleSum :: Sandpile Int -> Sandpile Int -> Sandpile Int
toppleSum existing changes = undefined 

topple :: Sandpile Int -> Sandpile Int
topple a = undefined