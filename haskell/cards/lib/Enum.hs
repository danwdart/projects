module Enum where

enumerate ∷ (Bounded a, Enum a) ⇒ [a]
enumerate = [minBound..maxBound]
