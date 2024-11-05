{-# LANGUAGE Safe #-}

module List where

-- >>> maybeIndex 1 [1,2,3]
-- Just 2

-- >>> maybeIndex 100 []
-- Nothing

-- >>> maybeIndex 100 [1,2,3]
-- Nothing

maybeIndex ∷ Int → [a] → Maybe a
maybeIndex index xs
  | index > length xs = Nothing
  | null xs = Nothing
  | otherwise = Just $ xs !! index
