module Numeric.Frobenius where

-- >>> frob2 2 8
-- Nothing
--

-- >>> frob2 1000 100
-- Nothing
--

-- >>> frob2 2 7
-- Just 5
--

-- >>> frob2 29 37
-- Just 1007
--

-- >>> frob2 100 51
-- Just 4949
--

-- >>> frob2 17 29
-- Just 447
--

frob2 ∷ Int → Int → Maybe Int
frob2 a b = if 1 == gcd a b then Just (a * b - a - b) else Nothing

