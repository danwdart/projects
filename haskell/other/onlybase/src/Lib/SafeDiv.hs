module Lib.SafeDiv (
    safeDiv
) where

safeDiv ∷ (Fractional a, Eq a) ⇒ a → a → Maybe a
safeDiv x y = if y == 0 then Nothing else Just (x / y)
