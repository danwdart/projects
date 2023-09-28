module Data.List.Nub (nubOn) where

import Data.Function (on)
import Data.List     (nubBy)

nubOn ∷ Eq a ⇒ (b → a) → [b] → [b]
nubOn = nubBy . on (==)
