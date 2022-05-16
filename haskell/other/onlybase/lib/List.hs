module List where

maybeIndex ∷ Int → [a] → Maybe a
maybeIndex index xs = if null xs then Nothing else Just $ xs !! index
