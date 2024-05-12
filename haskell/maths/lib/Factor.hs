module Factor where

divides ∷ (Integral a) ⇒ a → a → Bool
divides a b = b `mod` a == 0

-- >>> factors 24

factors ∷ Integral a ⇒ a → [a]
factors n = filter (`divides` n) ([1..(n `div` 2)] <> [n])

properFactors ∷ Integral a ⇒ a → [a]
properFactors n = filter (`divides` n) [2..(n `div` 2)]

abundance ∷ (Integral a, Fractional b) ⇒ a → b
abundance n = (fromIntegral . sum . factors $ n) / fromIntegral n
