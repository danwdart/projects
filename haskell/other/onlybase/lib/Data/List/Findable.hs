{-# LANGUAGE Safe #-}

module Data.List.Findable where

import Data.List qualified as L (find)

class Findable a b c where
    find :: a -> b -> Maybe c

instance Findable (a -> Bool) [a] a where
    find :: (a -> Bool) -> [a] -> Maybe a
    find = L.find

instance Findable [a] (a -> Bool) a where
    find :: [a] -> (a -> Bool) -> Maybe a
    find = flip L.find