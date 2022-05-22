module Frobenius where

-- >>> frob 2 8
-- Nothing
--

-- >>> frob 1000 100
-- Nothing
--

-- >>> frob 2 7
-- Just 5
--

-- >>> frob 29 37
-- Just 1007
--

-- >>> frob 100 51
-- Just 4949
--

-- >>> frob 17 29
-- Just 447
--

frob ∷ Int → Int → Maybe Int
frob a b = if 1 == gcd a b then Just (a * b - a - b) else Nothing

