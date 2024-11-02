{-# OPTIONS_GHC -Wno-x-partial #-}

module Sequence.Period where

-- >>> pisanoPeriod ([0,1,2,3,4,0,1,2,3,4] :: [Integer])
-- 5

-- >>> pisanoPeriod [2,1,3,4,2,1,3,4]
-- 4
--
pisanoPeriod ∷ forall a. (Eq a, Num a, Enum a) ⇒ [a] → a
pisanoPeriod xs = fst $ filter likeStart indexed !! 1
    where
        indexed = index (pairs xs)
        start = head indexed
        likeStart x = snd x == snd start
        index ∷ [(a, a)] → [(a, (a, a))]
        index = zip [0..]
        pairs xs' = zip xs' (tail xs')
