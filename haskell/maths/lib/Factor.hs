{-# LANGUAGE UnicodeSyntax #-}

module Factor where

import Data.List.Repeat (takeUntilSeen)

-- >>> 13 `divides` 24
-- False
--
-- >>> 12 `divides` 24
-- True
--
-- >>> 24 `divides` 12
-- False
--
divides ∷ (Integral a) ⇒ a → a → Bool
divides a b = b `mod` a == 0

-- >>> factors 24
-- [1,2,3,4,6,8,12,24]
--
factors ∷ Integral a ⇒ a → [a]
factors n = properFactors n <> [n]

-- >>> properFactors 24
-- [1,2,3,4,6,8,12]
--
properFactors ∷ Integral a ⇒ a → [a]
properFactors n = 1 : filter (`divides` n) [2..(n `div` 2)]

-- >>> aliquot 7
-- 1
--

-- >>> aliquot 6
-- 6
--
aliquot ∷ Integral a ⇒ a → a
aliquot = sum . properFactors

-- >>> abundance 12 :: Rational
-- 4 % 3
--
abundance ∷ (Integral a, Fractional b) ⇒ a → b
abundance n = (fromIntegral . sum . properFactors $ n) / fromIntegral n

aliquotSequence ∷ Integral a ⇒ a → [a]
aliquotSequence = takeUntilSeen . iterate aliquot
