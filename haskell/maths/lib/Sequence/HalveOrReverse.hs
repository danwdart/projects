module Sequence.HalveOrReverse where

import Data.Digits

{-# ANN module "HLint: ignore Avoid restricted function" #-}

reverseDigits :: Integer -> Integer
reverseDigits = unDigits 10 . digitsRev 10

halveOrReverse :: Integer -> Integer
halveOrReverse x
    | even x = x `div` 2
    | otherwise = reverseDigits x

-- >>> halveOrReverseRecursive <$> [1..99]
-- [1,1,3,1,5,3,7,1,9,5,11,3,13,7,15,1,17,9,19,5,3,11,1,3,13,13,9,7,1,15,31,1,33,17,35,9,37,19,39,5,7,3,17,11,9,1,37,3,37,13,51,13,53,9,55,7,57,1,59,15,1,31,9,1,7,33,19,17,3,35,71,9,73,37,75,19,77,39,79,5,9,7,19,3,1,17,39,11,37,9,91,1,93,37,95,3,97,37,99]
--
halveOrReverseRecursive :: Integer -> Integer
halveOrReverseRecursive x
    | odd x && odd (reverseDigits x) = x
    | otherwise = halveOrReverseRecursive (halveOrReverse x)

-- >>> halveOrReverseSequence
-- [1,1,3,2,5,3,7,4,9,5,11,6,31,7,51,8,71,9,91,10,12,11,32,12,52,13,72,14,92,15,13,16,33,17,53,18,73,19,93,20,14,21,34,22,54,23,74,24,94,25,15,26,35,27,55,28,75,29,95,30,16,31,36,32,56,33,76,34,96,35,17,36,37,37,57,38,77,39,97,40,18,41,38,42,58,43,78,44,98,45,19,46,39,47,59,48,79,49,99]
--

halveOrReverseSequence :: [Integer]
halveOrReverseSequence = halveOrReverse <$> [1..99]