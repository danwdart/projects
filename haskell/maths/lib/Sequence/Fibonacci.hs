{-# LANGUAGE ScopedTypeVariables #-}

module Sequence.Fibonacci where

fibs ∷ [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

seqF ∷ Int → Integer
seqF = (fibs !!)

naiveF ∷ forall a. Floating a ⇒ a → a
naiveF n = (phi ** n) / sqrt5
    where
        sqrt5 ∷ a
        sqrt5 = sqrt 5
        phi ∷ a
        phi = (sqrt5 + 1) / 2

-- some other binet formula
binetF ∷ forall a. Floating a ⇒ a → a
binetF n = (phi ** n - (recip phi ** n)) / sqrt5
    where
        sqrt5 ∷ a
        sqrt5 = sqrt 5
        phi ∷ a
        phi = (sqrt5 + 1) / 2

{-
binetF :: Floating a => a -> a
binetF n = (((1 + sqrt5) ** n) - ((1 - sqrt5) ** n)) / (2 ** n)
    where
        sqrt5 = sqrt 5

binetF :: Floating a => a -> a
binetF n = ((phi ** n) - ((- phi) ** (- n))) / sqrt5
    where
        sqrt5 = sqrt 5
        phi = (sqrt5 + 1) / 2
-}


-- >>> take 50 $ fibsModN 5
-- [0,1,1,2,3,0,3,3,1,4,0,4,4,3,2,0,2,2,4,1,0,1,1,2,3,0,3,3,1,4,0,4,4,3,2,0,2,2,4,1,0,1,1,2,3,0,3,3,1,4]
--

fibsModN ∷ Integer → [Integer]
fibsModN n = fmap (`mod` n) fibs
