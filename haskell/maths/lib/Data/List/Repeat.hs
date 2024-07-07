{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-x-partial #-}

module Data.List.Repeat (takeUntilRepeat, takeUntilSeen) where

import Data.List qualified as L

takeUntilRepeat ∷ Eq a ⇒ [a] → [a]
takeUntilRepeat xs = ((++) <$> fmap fst <*> pure . snd . last) .
    takeWhile (uncurry (/=)) $
    zip xs (tail xs)

-- >>> takeUntilSeen [1,2,1,2,1,2,1,2,1]
-- [1,2]
--

-- >>> takeUntilSeen [3,2,1,2,3]
-- [3,2,1]
--

-- >>> takeUntilSeen [1,2,3,4,5,1]
-- [1,2,3,4,5]
--
takeUntilSeen :: Eq a => [a] -> [a]
takeUntilSeen xs = go xs [] where
    go :: Eq a => [a] -> [a] -> [a]
    go [] _ = []
    go (x:xss) seen = case L.find (== x) seen of
        Nothing -> x : go xss (x:seen)
        Just _ -> []