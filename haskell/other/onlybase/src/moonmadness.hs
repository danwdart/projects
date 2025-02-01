{-# OPTIONS_GHC -Wno-x-partial #-}

module Main (main) where

import Control.Monad
import Data.Function
import Data.List

splitEvery ∷ Int → [a] → [[a]]
splitEvery _ [] = []
splitEvery n list = first : splitEvery n rest
  where
    (first,rest) = splitAt n list

splitIntIntoDigits ∷ Int → [Int]
splitIntIntoDigits = fmap (read . (: [])) . show

reduceDigitsIntoInt ∷ [Int] → Int
reduceDigitsIntoInt = read . concatMap show

maxLength ∷ [a] → [a] → Int
maxLength = on max length

minLength ∷ [a] → [a] → Int
minLength = on min length

moonAddWith ∷ (Int → Int → Int) → [Int] → [Int] → [Int]
moonAddWith fn a b = reverse . take (maxLength a b) $ zipWith fn (rppZeroes a) (rppZeroes b) where
    zeroes = repeat 0 :: [Int]
    rppZeroes n = reverse n <> zeroes

moonMulWith ∷ (Int → Int → Int) → (Int → Int → Int) → [Int] → [Int] → [Int]
moonMulWith fnMul fnAdd n1 n2 = foldl1 (moonAddWith fnAdd) (mulTwo fnMul n1 n2)

mulTwo ∷ Num a1 ⇒ (a2 → a2 → a1) → [a2] → [a2] → [[a1]]
mulTwo fnMul n1 n2 = transpose (concat (transpose (splitEvery maxLen (liftM2 fnMul n1 n2)):[threeTwoOneZero minLen])) where
    maxLen = maxLength n1 n2
    minLen = minLength n1 n2
    threeTwoOneZero ∷ Num a ⇒ Int → [[a]]
    threeTwoOneZero n = reverse . tail $ take n (inits $ repeat 0)

(<<+>>) ∷ Int → Int → Int
a <<+>> b = reduceDigitsIntoInt $ moonAddWith max (splitIntIntoDigits a) (splitIntIntoDigits b)

(<<*>>) ∷ Int → Int → Int
a <<*>> b = reduceDigitsIntoInt $ moonMulWith min max (splitIntIntoDigits a) (splitIntIntoDigits b)

main ∷ IO ()
main = print [
    [show x <> (" <<+>> " <> (show y <> (" = " <> show (x <<+>> y)))) | x <- [0..20], y <- [0..20]],
    [show x <> (" <<*>> " <> (show y <> (" = " <> show (x <<*>> y)))) | x <- [0..20], y <- [0..20]]]
