module Numeric.ProjectEuler.Solution5 where

{-# ANN module "HLint: ignore Avoid restricted function" #-}

solution ∷ Integer
solution = sum nn ^ (2 :: Integer) - sum (fmap (^ (2 :: Integer)) nn) where
    nn = [1..100 :: Integer]
