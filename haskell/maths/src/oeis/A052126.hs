module Main where

import           Data.List.Safer
import           Data.Numbers.Primes

{-# ANN module "HLint: ignore Avoid restricted function" #-}

oeisA052126 ∷ [Integer]
oeisA052126 = product . initOrEmpty . primeFactors <$> [1..]

main ∷ IO ()
main = print . take 30 $ oeisA052126
