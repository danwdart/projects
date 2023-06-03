{-# LANGUAGE Safe #-}

module Control.Category.LambdaCalculus.SKI where

class SKI where
    s :: cat (cat a (cat b c)) (cat b (cat a c))
    k :: cat (cat a b) a
    i :: cat a a