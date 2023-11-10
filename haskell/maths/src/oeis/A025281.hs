module Main (main) where

import Data.List           (group)
import Data.Numbers.Primes

(!) ∷ Integer → Integer
(!) 0 = 1
(!) 1 = 1
(!) n = n * ((n-1) !)

values ∷ [Integer]
values = sum .
    (\n ->
        fmap (
            (\(x, r) -> x * fromIntegral r) .
            (\xs -> (head xs, length xs))
        ) .
        group $ primeFactors (n !)
    ) <$> [1..20]


main ∷ IO ()
main = print values
