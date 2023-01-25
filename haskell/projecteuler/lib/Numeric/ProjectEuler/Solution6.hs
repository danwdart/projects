module Numeric.ProjectEuler.Solution6 where

import Data.Numbers.Primes

{-# ANN module "HLint: ignore Avoid restricted function" #-}

solution ∷ Integer
solution = primes !! 10000 -- idx 0