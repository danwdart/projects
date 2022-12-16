{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Collatz where

import           Numeric.Natural

-- $setup
-- >>> :set -XUnicodeSyntax
--

-- |
-- >>> chain 3
-- [3,10,5,16,8,4,2,1]
--

-- |
-- >>> chain 23
-- [23,70,35,106,53,160,80,40,20,10,5,16,8,4,2,1]
--

-- |
-- >>> chain 196
-- [196,98,49,148,74,37,112,56,28,14,7,22,11,34,17,52,26,13,40,20,10,5,16,8,4,2,1]
--

-- |
-- >>> chain 400
-- [400,200,100,50,25,76,38,19,58,29,88,44,22,11,34,17,52,26,13,40,20,10,5,16,8,4,2,1]
--

collatz ∷ Natural → Natural
collatz 1 = 1
collatz n -- -Wincomplete-patterns?
    | even n = n `div` 2
    | odd n = n * 3 + 1

chain ∷ Natural → [Natural]
chain n = n : chain (collatz n)

-- collatzReverse :: Integer -> [Integer]
-- collatzReverse 1 = [2]
-- collatzReverse n = [n * 2, (n - 1 / 3)] -- what's this again?
