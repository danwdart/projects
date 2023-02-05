module Numeric.ProjectEuler.Solution4 where

{-# ANN module "HLint: ignore Avoid restricted function" #-}

solution ∷ Integer
solution = maximum . filter (\x -> read (reverse (show x)) == x) $ (*) <$> [100..999] <*> [100..999]
