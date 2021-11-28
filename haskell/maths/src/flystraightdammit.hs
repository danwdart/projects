{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

divInt :: Integer -> Integer -> Integer
divInt x y = round ((fromInteger x :: Double) / (fromInteger y :: Double))

numbers :: [(Integer, Integer)]
numbers = go (go [(1,1),(0,1)]) where
    go :: [(Integer, Integer)] -> [(Integer, Integer)]
    -- who cares
    go [] = []
    go [(_, _)] = []
    -- here's the real deal
    go all'@((i1,x1):_) = (
        i1 + 1,
        if gcd x1 (i1 + 1) == 1
            then
                (i1 + 1) + x1
            else
                i1 `divInt` gcd x1 (i1 + 1)
        ):all'

main :: IO ()
main = print $ take 10 numbers