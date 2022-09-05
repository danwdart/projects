{-# OPTIONS_GHC -Wno-unused-imports #-}

module Semiprimes where

import Data.List
import Data.Numbers.Primes

{-# ANN module "HLint: ignore Avoid restricted function" #-}

-- fixed size matrix with proper typed transpose?

-- Interesting: data structure which stores a given spreadsheet. Maybe list of fixed typed length array.
-- Or just pad with blanks.

-- TODO: graph it!

-- >>> moduloMultiplication 7
-- (Error while loading modules for evaluation)
-- [1 of 1] Compiling Semiprimes       ( /home/dwd/code/mine/multi/projects/haskell/maths/lib/Semiprimes.hs, interpreted )
-- <BLANKLINE>
-- /home/dwd/code/mine/multi/projects/haskell/maths/lib/Semiprimes.hs:3:1-26: error:
--     Could not find module ‘Data.Numbers.Primes’
--     Use -v (or `:set -v` in ghci) to see a list of the files searched for.
-- Failed, no modules loaded.
--

-- >>> ($) <$> [1..10] <*> [1..10]
-- (Error while loading modules for evaluation)
-- [1 of 1] Compiling Semiprimes       ( /home/dwd/code/mine/multi/projects/haskell/maths/lib/Semiprimes.hs, interpreted )
-- <BLANKLINE>
-- /home/dwd/code/mine/multi/projects/haskell/maths/lib/Semiprimes.hs:3:1-26: error:
--     Could not find module ‘Data.Numbers.Primes’
--     Use -v (or `:set -v` in ghci) to see a list of the files searched for.
-- Failed, no modules loaded.
--


-- sig like outerProduct from utility-ht
f2D :: (a -> b -> c) -> [a] -> [b] -> [[c]]
f2D f xs ys = [[f x y | x <- xs] | y <- ys]

-- todo pointfree \f g x y -> f (g x y) = f . g
-- $> moduloMultiplication 10

moduloMultiplication :: Integer -> [[Integer]]
moduloMultiplication m = f2D (\x y -> mod (x * y) m) [0..m-1] [0..m-1]


p1, p2, s :: Integer
p1 = primes !! 10113
p2 = primes !! 19736
s = p1 * p2
