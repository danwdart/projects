module List where

-- >>> maybeIndex 1 [1,2,3]
-- Just 2

-- >>> maybeIndex 100 []
-- Nothing

-- >>> maybeIndex 100 [1,2,3]
-- Prelude.!!: index too large

maybeIndex ∷ Int → [a] → Maybe a
maybeIndex index xs = if null xs then Nothing else Just $ xs !! index
