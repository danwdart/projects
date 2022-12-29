{-# LANGUAGE DerivingStrategies #-}
{-# OPTIONS_GHC -Wwarn #-}

{-}
data Combination = Sum Combination Combination |
    Product Combination Combination |
    Plain Int |
    Root Int

instance Show Combination where
    show (Sum c1 c2)     = "(" <> (show c1 <> (" + " <> (show c2 <> ")")))
    show (Product c1 c2) = "(" <> (show c1 <> (show c2 <> ")"))
    show (Plain a)       = show a
    show (Root a)        = "√" <> show a

instance Num Combination where
    c1 + c2 = undefined
    c1 * c2 = undefined
    abs c1 = undefined
    signum c1 = undefined
    negate c1 = undefined
    fromInteger = Plain . fromInteger

main ∷ IO ()
main = print $ Sum (Product (Plain 2) (Root 2)) (Product (Plain 3) (Root 3))
-}

-- Let's do it a different way.

import Data.Ratio

newtype Algebraic = Algebraic {
    getAlgebraic :: [(Integer, Rational)] -- a1 x ^ b1 + a2 x ^ b2
} deriving stock (Eq, Show)

instance Num Algebraic where
    Algebraic x + Algebraic y = undefined
    Algebraic x * Algebraic y = undefined
    abs (Algebraic x) = undefined
    signum (Algebraic x) = error "Can't signum an Algebraic"
    fromInteger x = Algebraic [(x, 0)]
    negate (Algebraic x) = undefined

newtype Solution = Solution {
    getSolution :: [(Integer, Integer, Rational)] -- a1 b1 ^ c1 + a2 b2 ^ c2
} deriving stock (Eq, Show)

instance Num Solution where
    Solution x + Solution y = undefined
    Solution x * Solution y = undefined
    abs (Solution x) = undefined
    signum (Solution x) = undefined
    fromInteger x = Solution [(1, x, 1)]
    negate (Solution x) = undefined

{-# WARNING simplifySolution "Does not work yet" #-}
simplifySolution :: Solution -> Solution
simplifySolution = id -- for now

evalAlgebraic :: Integer -> Algebraic -> Solution
evalAlgebraic x = simplifySolution . Solution . fmap (\(a, b) -> (a, x, b)) . getAlgebraic

sqrtx :: Algebraic
sqrtx = Algebraic [(1, 1 % 2)]

sqrt2 :: Solution
sqrt2 = evalAlgebraic 2 sqrtx

cbrtx :: Algebraic
cbrtx = Algebraic [(1, 1 % 3)]

cbrt2 :: Solution
cbrt2 = evalAlgebraic 2 cbrtx

main :: IO ()
main = pure ()