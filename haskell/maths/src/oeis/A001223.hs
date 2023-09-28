
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import Data.Map.Lazy       (Map, fromListWith)
import Data.Numbers.Primes

-- A001223
gaps ∷ [Integer]
gaps = uncurry (-) <$> zip (tail primes) primes

freq ∷ (Ord a) ⇒ [a] → Map a Integer
freq xs = fromListWith (+) [(c, 1) | c <- xs]

main ∷ IO ()
main = print . freq $ take 100000 gaps
