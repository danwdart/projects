module Main where

import           Data.List.Safer
import           Data.Numbers.Primes

{-# ANN module "HLint: ignore Avoid restricted function" #-}

oeisA032742 ∷ [Integer]
oeisA032742 = product . tailOrEmpty . primeFactors <$> [1..]

main ∷ IO ()
main = print . take 30 $ oeisA032742
