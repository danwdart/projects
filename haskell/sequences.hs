module Main (main) where

import Data.List

continueSequence1 :: (Num a) => (a -> a -> a) -> [a] -> [a]
continueSequence1 f (x1:x2:xs) = ((f x1 x2):x1:x2:xs)

makeSeq :: (Num a) => (a -> a -> a) -> [a] -> [[a]]
makeSeq fn nums = concat [reverse (tail (tails nums)), iterate (continueSequence1 fn) nums]

fibonacci :: (Num a) => [[a]] 
fibonacci = makeSeq (+) [1, 1]
    
lucas :: (Num a) => [[a]]
lucas = makeSeq (+) [1, 2]

main :: IO ()
main = print [fibonacci !! 5, lucas !! 5]