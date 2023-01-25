module Numeric.ProjectEuler.Solution2 where

{-# ANN module "HLint: ignore Avoid restricted function" #-}

solution ∷ Integer
solution = sum . filter even $ last (takeWhile (all (< 4000000)) $ iterate sumIter [2,1])
    where
        sumIter (a:b:xs) = (a + b):(a:b:xs)
        sumIter _        = []