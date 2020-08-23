module Data.List.Nub (nubOn) where

import Data.List (nubBy)
import Data.Function (on)

nubOn :: Eq a => (b -> a) -> [b] -> [b]
nubOn = nubBy . on (==)