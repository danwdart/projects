{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Data.Functor.Multi where

import Data.Monoid
-- bimap isn't quite enough, there should be a generalised version of that

-- I'd like to write something like this:
--
-- >>> cartesianTest
-- [5,6,7,6,7,8,7,8,9,-3,-4,-5,-2,-3,-4,-1,-2,-3,4,5,6,8,10,12,12,15,18]
--a
cartesianTest ∷ [Int]
cartesianTest = [(+), (-), (*)] <*> [1,2,3] <*> [4,5,6]

-- but that's just the cartesian product of some things. And Ap won't help here.

apTest ∷ [Int]
apTest = [(+), (-), (*)] <*> [1,2,3] <*> [4,5,6]

-- >>> manualOne [(+ 1), (* 2)] [1, 2]
-- [2,4]
--

manualOne ∷ [a → b] → [a] → [b]
manualOne [] []         = []
manualOne (f:fs) (x:xs) = f x : manualOne fs xs
manualOne _ _           = error "Incorrect list lengths"

-- >>> manualTwo [(+), (*)] [1, 2] [2, 3]
-- [3,6]
--
manualTwo ∷ [a → b → c] → [a] → [b] → [c]
manualTwo [] [] []             = []
manualTwo (f:fs) (x:xs) (y:ys) = f x y : manualTwo fs xs ys
manualTwo _ _ _                = error "Incorrect list lengths"

-- multiTest :: [Int]
-- multiTest = _ [(+), (-), (*)] [1,2,3] [4,5,6]


-- >>> fmap (+3) [1, 2]
-- [4,5]
--

-- >>> sequenceA [(+ 1), (+ 2)] 3
-- [4,5]
--

-- Let's see...
-- single function multi value = fmap
-- multi function multi value
-- multi function single value = sequenceA

-- using function as a monad, you can also...
