module Main (main) where

import Data.List

continueSequence1 :: (Integer -> Integer -> Integer) -> [Integer] -> [Integer]
continueSequence1 f (x1:x2:xs) = (f x1 x2):x1:x2:xs
continueSequence1 _ [x] = [x]
continueSequence1 _ [] = []

makeSeq :: (Integer -> Integer -> Integer) -> [Integer] -> [[Integer]]
makeSeq fn nums = reverse (tail (tails nums)) ++ iterate (continueSequence1 fn) nums

fibonacci :: [[Integer]]
fibonacci = makeSeq (+) [1, 1]

lucas :: [[Integer]]
lucas = makeSeq (+) [1, 2]

main :: IO ()
main = print [
    fibonacci !! (5 :: Int),
    lucas !! (5 :: Int)
    ]
