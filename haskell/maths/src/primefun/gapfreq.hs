{-# LANGUAGE OverloadedLists #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import Data.Numbers.Primes
import Data.Map.Lazy (Map, fromListWith)

gaps :: [Integer]
gaps = uncurry (-) <$> zip (tail primes) primes 

freq :: (Eq a, Ord a) => [a] -> Map a Integer
freq xs = fromListWith (+) [(c, 1) | c <- xs]

main :: IO ()
main = print . freq $ take 100000 gaps