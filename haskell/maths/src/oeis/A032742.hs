module Main (main) where

import Data.Numbers.Primes

oeisA032742 ∷ [Integer]
oeisA032742 = product . drop 1 . primeFactors <$> [1..]

main ∷ IO ()
main = print . take 30 $ oeisA032742
