{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main (main) where

-- https://oeis.org/A133058

divInt ∷ Integer → Integer → Integer
divInt x y = round (
    (fromInteger x :: Double) /
    (fromInteger y :: Double)
    )

-- | Iterate a function n times on a starting value.
-- | >>> iter 5 succ 1 == 6
iter ∷ Integer → (a → a) → a → a
iter 0 _ x = x
iter 1 f x = f x
iter n f x = f (iter (n - 1) f x)

iterNumbers ∷ [(Integer, Integer)] → [(Integer, Integer)]
iterNumbers [] = []
iterNumbers [(_, _)] = []
iterNumbers all'@((nMinus1,aOfNMinus1):_) = (
    n,
    if gcd aOfNMinus1 n == 1
        then
            aOfNMinus1 + n + 1
        else
            aOfNMinus1 `divInt` gcd aOfNMinus1 n

    ):all'
    where
        n = nMinus1 + 1

start ∷ [(Integer, Integer)]
start = [(1,1),(0,1)]

upTo ∷ Integer → [Integer]
upTo n = fmap snd . reverse $ iter n iterNumbers start

-- Now we should plot stuff!
main ∷ IO ()
main = print $ upTo 642
