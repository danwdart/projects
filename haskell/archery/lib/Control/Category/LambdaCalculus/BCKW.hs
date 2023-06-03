{-# LANGUAGE Safe #-}

module Control.Category.LambdaCalculus.BCKW where

class SKI where
    b :: cat (cat (cat b c) (cat a b)) (cat a c)
    c :: cat (cat a (cat b c)) (cat b (cat a c))
    k :: cat (cat a b) a
    w :: cat (cat (cat (cat a a) b) a) b