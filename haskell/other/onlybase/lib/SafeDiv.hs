{-# LANGUAGE Safe #-}

module SafeDiv (
    safeDiv
) where

-- >>> safeDiv 1 10
-- Just 0.1

-- >>> safeDiv 1 0
-- Nothing

safeDiv ∷ (Fractional a, Eq a) ⇒ a → a → Maybe a
safeDiv x y = if y == 0 then Nothing else Just (x / y)
{-# INLINABLE safeDiv #-}
