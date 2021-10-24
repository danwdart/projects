{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Data.Numbers.Primes

main :: IO ()
main = do
    print [s `mod` (2 ^ n) | n <- [1..10::Integer]]


p1, p2, s :: Integer
p1 = primes !! 10113
p2 = primes !! 19736
s = p1 * p2
