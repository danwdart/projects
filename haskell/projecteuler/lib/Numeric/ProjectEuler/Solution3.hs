module Numeric.ProjectEuler.Solution3 where

import Data.Numbers.Primes

{-# ANN module "HLint: ignore Avoid restricted function" #-}

solution ∷ Integer
solution = last  $ primeFactors 600851475143