module Polynomial where

newtype Polynomial = Polynomial {
    getPolynomial :: [Integer]
} deriving (Eq, Show)

-- >>> Polynomial [1, 2] + Polynomial [2, 3]
instance Num Polynomial where
    Polynomial [] + Polynomial [] = Polynomial []
    Polynomial (a:as) + Polynomial (b:bs) = Polynomial $ (a + b) : getPolynomial (Polynomial as + Polynomial bs)
    Polynomial as + Polynomial [] = Polynomial as
    Polynomial [] + Polynomial as = Polynomial as
    Polynomial [] * Polynomial [] = Polynomial []
    Polynomial (a:as) * Polynomial (b:bs) = 