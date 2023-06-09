{-# LANGUAGE Safe #-}

module Control.Category.Curry where

class Curry cat where
    curry' :: cat (cat (a, b) c) (cat a (cat b c))
    uncurry' :: cat (cat a (cat b c)) (cat (a, b) c)

instance Curry (->) where
    curry' = curry
    uncurry' = uncurry
