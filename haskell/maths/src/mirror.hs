{- see: https://en.wikipedia.org/wiki/Lychrel_number -}

module Main (main) where

import Data.Digits
import Data.Foldable
import Prelude

-- there's probably a more efficient way to do this.
isPalindromicDigits ∷ [Integer] → Bool
isPalindromicDigits n = n == reverse n

isPalindromic ∷ Integer → Bool
isPalindromic = isPalindromicDigits . digitsRev 10

reverseDigits ∷ Integer → Integer
reverseDigits = unDigits 10 . digitsRev 10

addToReverse ∷ Integer → Integer
addToReverse x = x + reverseDigits x

probableLychrelsInBase10 ∷ [Integer]
probableLychrelsInBase10 = [
    196,
    295,
    394,
    493,
    592,
    689,
    691,
    788,
    790,
    879,
    887,
    978,
    986,
    1495,
    1497,
    1585,
    1587,
    1675,
    1677,
    1765,
    1767,
    1855,
    1857,
    1945,
    1947,
    1997
    ]

nextPalindromeAdd ∷ Integer → Maybe Integer
{-# ANN nextPalindromeAdd "HLint: ignore Avoid restricted function" #-}
nextPalindromeAdd x
    | x `elem` probableLychrelsInBase10 = Nothing
    | otherwise = Just $ until isPalindromic addToReverse x

palindromeAnswer ∷ Integer → (Integer, Maybe Integer)
palindromeAnswer x = (x, nextPalindromeAdd x)

formatAnswer ∷ (Integer, Maybe Integer) → String
formatAnswer (x, answer) = show x <> " => " <> maybe "Probable Lychrel" show answer

main ∷ IO ()
main = do
    traverse_ putStrLn $ formatAnswer <$> {- A240510 -} filter (\(_, answer) -> Just 8813200023188 == answer) (palindromeAnswer <$> [1..2000])
