module Numeric.ProjectEuler.Solution1 where

{-# ANN module "HLint: ignore Avoid restricted function" #-}

-- sum $ filter (\x -> mod x 5 == 0 || mod x 3 == 0) [0..999]

solution ∷ Integer
solution = sum $ filter (\x -> any (\y -> mod x y == 0) [3,5]) [0..999]
