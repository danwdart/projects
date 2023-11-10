module Main (main) where

import Data.Numbers.Primes

stuff ∷ [(Integer, Integer, Integer)]
stuff = [(
    (primes !! 299 * primes !! 926) `mod` 2 ^ x,
    (primes !! 299) `mod` 2 ^ x,
    (primes !! 926) `mod` 2 ^ x) | x <- [1..100] :: [Integer]
    ]

main ∷ IO ()
main = print stuff
