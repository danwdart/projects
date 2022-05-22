
module NumList where

import           Data.Ratio

toNums ∷ Int → [Int] → [Int]
toNums a = fmap (numerator . (% a))

toNumList ∷ Int → [Int]
toNumList a = toNums a [1..a]
