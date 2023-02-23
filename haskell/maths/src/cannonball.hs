{-# OPTIONS_GHC -Wwarn #-}

module Main where

{-
3 0 = 0
3 1 = 1 = 3 0 + 1
3 2 = 3 = 3 1 + 2
3 3 = 6 = 3 2 + 3
3 4 = 10 = 3 2 + 4

n(n-1)/2

4 0 = 0
4 1 = 1 = 4 0 + 1
4 2 = 4 = 4 1 + 2 + 1
4 3 = 9 = 4 2 + 3 + 2
4 4 = 16 = 4 3 + 4 + 3

n^2

5 0 = 0
5 1 = 1 = 5 0 + 1
5 2 = 5 = 5 1 + 421

??

recurrence relation

formula
-}

polygon :: Integer -> Integer -> Integer
polygon sides sideLength = undefined

pyramid :: Integer -> Integer -> Integer
pyramid sides sideLength = undefined

main :: IO ()
main = pure ()