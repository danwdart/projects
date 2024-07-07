{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-incomplete-patterns -Wno-x-partial #-}

module Main (main) where

main ∷ IO ()
main = pure ()

primes ∷ [Integer]
primes = sieve [2..] where
    sieve (p:ps) = p : sieve [x | x <- ps, mod x p /= 0]

eitherSides ∷ [Bool]
eitherSides = fmap (== 5) . drop 2 $ fmap (`mod` 6) primes

pairs ∷ [a] → [(a, a)]
pairs n = zip n (tail n)

primePairs ∷ [(Integer, Integer)]
primePairs = pairs primes

-- twin, cousin etc
diffs ∷ [Integer]
diffs = fmap (`div` 2) . tail $ fmap (uncurry subtract) primePairs

aSemiprime ∷ Integer
aSemiprime = (primes !! 150) * (primes !! 422)

coprime ∷ Integer → Integer → Bool
coprime a b = 1 == gcd a b

totient ∷ Integer → Integer
totient n = fromIntegral . length $ filter (coprime n) [1..n]

is ∷ (Integer → Bool) → [Integer]
is = flip filter [1..]
