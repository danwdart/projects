{-# OPTIONS_GHC -Wno-unused-imports #-}
-- Multiples of 5 where Pisano periods of Fibonacci numbers A001175 and Lucas numbers A106291 agree.
module Main where

import           Sequence.Fibonacci
import           Sequence.Lucas
import           Sequence.Period

{-# ANN module "HLint: ignore Avoid restricted function" #-}

indexEqual ∷ Eq a ⇒ [a] → [a] → [Integer]
indexEqual xs ys = go xs ys 0 [] where
    go ∷ Eq a ⇒ [a] → [a] → Integer → [Integer] → [Integer]
    go [] [] _ list = list
    go (x:xs') (y:ys') ix list
        | x == y = ix : go xs' ys' (ix + 1) list
        | otherwise = go xs' ys' (ix + 1) list
    go _ _ _ _ = error "Invalid number of arguments"

result ∷ [Integer]
result = (* 5) . (+ 1) <$> indexEqual (fmap (pisanoPeriod . fibsModN . (* 5))  [1..]) (fmap (pisanoPeriod . lucasesModN . (* 5)) [1..])

-- What about / 5

-- $> take 20 resultDiv5

resultDiv5 ∷ [Integer]
resultDiv5 = (`div` 5) <$> result

main ∷ IO ()
main = print $ take 200 result
