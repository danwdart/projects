{-# OPTIONS_GHC -Wno-unused-local-binds #-}

module Main where

import Data.Digits
import Data.Maybe

main :: IO ()
main = print . showBinary $ Main.iterate 4 (fromBinary [0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,0])

showBinary :: Int -> String
showBinary = concatMap show . toBinary

-- Stolen from utility-ht
padLeft :: a -> Int -> [a] -> [a]
padLeft c n xs = replicate (n - length xs) c <> xs

toBinary :: Int -> [Int]
toBinary = padLeft 0 16 . digits 2

fromBinary :: [Int] -> Int
fromBinary = unDigits 2

initialValue :: Int
initialValue = 210

-- we're going to need an indexed list, here. For now let's just implement with a zip:
toIndexed :: [a] -> [(Int, a)]
toIndexed = zip [0..]

fromIndexed :: [(Int, a)] -> [a]
fromIndexed = fmap snd

-- probably should just use map at this point
lookupDefault :: Eq key => val -> key -> [(key, val)] -> val
lookupDefault def key list = fromMaybe def $ lookup key list -- todo eta

-- Alternatively we can use a non-fmap-type operation to traverse real lists. Hmm... I wonder how we might do that.

-- For each bit of the imput, determine whether it will be turned on based on the patterns of it and its neighbours.
-- for each bit:
    -- get the number of the pattern around it n, and check the nth bit of the rule to see whether to persist the bit..
    -- e.g. bit 3, 4, 5 have  1, 1, 0 turned on. 110 is 6 and bit 6 of the rule is 1, so set bit 4 of the output to 1.
iterate :: Int -> Int -> Int
iterate rule val = fromBinary $ fmap (
    \(index, _bit) -> binRule !! fromBinary [
            lookupDefault 0 (index - 1) ixBinRep,
            lookupDefault 0 index ixBinRep,
            lookupDefault 0 (index + 1) ixBinRep
            ]
    ) ixBinRep
    where
        ixBinRule :: [(Int, Int)]
        ixBinRule = toIndexed binRule
        binRule :: [Int]
        binRule = padLeft 0 8 $ digits 2 rule
        ixBinRep :: [(Int, Int)]
        ixBinRep = toIndexed binRep
        binRep :: [Int]
        binRep = toBinary val
