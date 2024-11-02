{-# OPTIONS_GHC -Wno-x-partial #-}

module Sequence.Lucas where

lucases ∷ [Integer]
lucases = 2 : 1 : zipWith (+) lucases (tail lucases)

seqL ∷ Int → Integer
seqL = (lucases !!)

naiveL ∷ forall a. (Floating a) ⇒ a → a
naiveL n = phi ** n
    where
        sqrt5 ∷ a
        sqrt5 = sqrt 5
        phi ∷ a
        phi = (sqrt5 + 1) / 2

-- some other binet formula
binetL ∷ forall a. (Floating a) ⇒ a → a
binetL n = phi ** n - (recip phi ** n)
    where
        sqrt5 ∷ a
        sqrt5 = sqrt 5
        phi ∷ a
        phi = (sqrt5 + 1) / 2

{-
binetL :: Floating a => a -> a
binetL n = (((1 + sqrt5) ** n) - ((1 - sqrt5) ** n)) / ((2 ** n) * sqrt5)
    where
        sqrt5 = sqrt 5

binetL :: Floating a => a -> a
binetL n = (phi ** n) - ((- phi) ** (- n))
    where
        sqrt5 = sqrt 5
        phi = (sqrt5 + 1) / 2
-}

-- >>> take 10 $ lucasesModN 5
-- [2,1,3,4,2,1,3,4,2,1]
--

lucasesModN ∷ Integer → [Integer]
lucasesModN n = fmap (`mod` n) lucases
