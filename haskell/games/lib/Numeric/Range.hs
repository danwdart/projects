module Numeric.Range where

import Control.Exception.RangeException

mkRanged ∷ (Ord a) ⇒ a → a → a → Either (RangeException a) a
mkRanged lowest highest n
    | n < lowest = Left . NumberTooSmall $ n
    | n > highest = Left . NumberTooBig $ n
    | otherwise = Right n

mkWithRange ∷ (Ord a) ⇒ (a → b) → a → a → a → Either (RangeException a) b
mkWithRange f lowest highest n
    | n < lowest = Left . NumberTooSmall $ n
    | n > highest = Left . NumberTooBig $ n
    | otherwise = Right . f $ n
