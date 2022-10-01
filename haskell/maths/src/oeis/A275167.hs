{-# OPTIONS_GHC -Wno-unused-imports #-}

-- Pisano periods of A275124.
module Main where

import Sequence.Fibonacci
import Sequence.Lucas
import Sequence.Period

{-# ANN module "HLint: ignore Avoid restricted function" #-}

valueEqual :: [Integer] -> [Integer] -> [Integer]
valueEqual xs ys = go xs ys 0 [] where
    go :: [Integer] -> [Integer] -> Integer -> [Integer] -> [Integer]
    go [] [] _ list = list
    go (x:xs') (y:ys') ix list
        | x == y = x : go xs' ys' (ix + 1) list
        | otherwise = go xs' ys' (ix + 1) list
    go _ _ _ _ = error "Invalid number of arguments"

result :: [Integer]
result = valueEqual (fmap (pisanoPeriod . fibsModN . (* 5))  [1..]) (fmap (pisanoPeriod . lucasesModN . (* 5)) [1..])

-- Seems these all divide by 20...

-- >>>> nonDiv20

nonDiv20 :: [Integer]
nonDiv20 = fmap fst . filter (\(_, r) -> r /= 0) $ (`divMod` 20) <$> result

-- $> take 200 resultDiv20
resultDiv20 :: [Integer]
resultDiv20 = (`div` 20) <$> result

main ∷ IO ()
main = print $ take 200 result
