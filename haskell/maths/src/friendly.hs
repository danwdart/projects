{-# OPTIONS_GHC -Wno-unused-imports  #-}

module Main where

import           Data.List           (sort)
import           Data.Numbers.Primes
import           Data.Ratio

{-# ANN module "HLint: ignore Avoid restricted function" #-}

divides ∷ Integer → Integer → Bool
divides x y = x `mod` y == 0

factors ∷ Integer → [Integer]
factors n = filter (\x -> n `divides` x) [1..n `div` 2] <> [n]

properFactors ∷ Integer → [Integer]
properFactors n = filter (\x -> n `divides` x) [2..n `div` 2]

sumFact ∷ Integer → Integer
sumFact = sum . factors

sumProper ∷ Integer → Integer
sumProper = sum . properFactors

index ∷ Integer → Rational
index n = sumFact n % n

indexProper ∷ Integer → Rational
indexProper n = sumProper n % n

appendToVal ∷ (Eq key, Semigroup val) ⇒ key → val → [(key, val)] → [(key, val)]
appendToVal key val [] = [(key, val)]
appendToVal key val ((oldKey, oldVal):xs)
    | oldKey == key = (oldKey, oldVal <> val) : xs
    | otherwise = (oldKey, oldVal) : appendToVal key val xs -- seems to repeat?

resultUpTo ∷ Integer → [(Rational, [Integer])]
resultUpTo maxN = go [1..maxN] [] where
    go ∷ [Integer] → [(Rational, [Integer])] → [(Rational, [Integer])]
    go [] sofar     = sofar
    go (x:xs) sofar = go xs $ appendToVal (index x) [x] sofar

main ∷ IO ()
main = mapM_ print . sort $ resultUpTo 100
