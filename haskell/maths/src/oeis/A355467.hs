module Main (main) where

import Data.Numbers.Primes

main ∷ IO ()
main = print $ take 200 result

result ∷ [Integer]
result = fmap (
    \n -> head (
        dropWhile (
            \m -> length (primeFactors m :: [Integer]) <= length (primeFactors n :: [Integer])
        )
        [n..]
    )
    ) [1..]
