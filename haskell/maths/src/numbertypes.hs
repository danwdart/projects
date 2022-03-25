{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-imports -Wno-incomplete-patterns -Wno-unused-matches -Wno-type-defaults#-}

import           Data.Complex
import           Data.Ratio

data NumberType a = Finite a |
    OverPositiveInfinity a |
    OverNegativeInfinity a |
    OverZero a |
    PositiveInfinity |
    NegativeInfinity |
    Undefined |
    Anything deriving (Eq, Read)

instance (Show a) ⇒ Show (NumberType a) where
    show (Finite a)               = show a
    show (OverPositiveInfinity a) = show a <> "/+inf"
    show (OverNegativeInfinity a) = show a <> "/-inf"
    show (OverZero a)             = show a <> "/0"
    show PositiveInfinity         = "+inf"
    show NegativeInfinity         = "-inf"
    show Undefined                = "undef"
    show Anything                 = "any"

instance (Num a) ⇒ Num (NumberType a) where
    (Finite a) + PositiveInfinity         = PositiveInfinity
    PositiveInfinity + (Finite a)         = PositiveInfinity
    PositiveInfinity + PositiveInfinity   = PositiveInfinity
    (Finite x) + (OverPositiveInfinity y) = Undefined
    (Finite x) + (OverNegativeInfinity y) = Undefined
    (Finite x) + (OverZero y)             = Undefined
    (Finite x) + (Finite y)               = Finite (x + y)

    (Finite a) - PositiveInfinity         = NegativeInfinity
    PositiveInfinity - (Finite a)         = PositiveInfinity
    PositiveInfinity - PositiveInfinity   = Anything
    (Finite x) - (OverPositiveInfinity y) = Undefined
    (Finite x) - (OverNegativeInfinity y) = Undefined
    (Finite x) - (OverZero y)             = Undefined

    (Finite a) * PositiveInfinity         = PositiveInfinity
    PositiveInfinity * (Finite a)         = PositiveInfinity
    PositiveInfinity * PositiveInfinity   = PositiveInfinity
    (Finite x) * (OverPositiveInfinity y) = Undefined
    (Finite x) * (OverNegativeInfinity y) = Undefined
    (Finite x) * (OverZero y)             = Undefined
    (Finite x) * (Finite y)               = Finite (x * y)

    negate PositiveInfinity         = NegativeInfinity
    negate NegativeInfinity         = PositiveInfinity
    negate (Finite x)               = Finite (negate x)
    negate (OverPositiveInfinity _) = Undefined
    negate (OverNegativeInfinity _) = Undefined
    negate (OverZero _)             = Undefined

    abs PositiveInfinity         = PositiveInfinity
    abs NegativeInfinity         = PositiveInfinity
    abs (Finite x)               = Finite (abs x)
    abs (OverPositiveInfinity _) = Undefined
    abs (OverNegativeInfinity _) = Undefined
    abs (OverZero _)             = Undefined

    signum PositiveInfinity         = Finite 1
    signum NegativeInfinity         = Finite (-1)
    signum (OverPositiveInfinity _) = Undefined
    signum (OverNegativeInfinity _) = Undefined
    signum (OverZero _)             = Undefined
    signum (Finite x)               = Finite (signum x)

    fromInteger = Finite . fromInteger

instance (Fractional a, Eq a) ⇒ Fractional (NumberType a) where
    (Finite 0) / (Finite 0)               = Anything
    (Finite x) / (Finite 0)               = OverZero x
    (Finite x) / (Finite y)               = Finite (x/y)
    (Finite p) / (OverPositiveInfinity _) = Undefined
    (Finite p) / (OverNegativeInfinity _) = Undefined
    (Finite p) / (OverZero _)             = Undefined
    (Finite p) / PositiveInfinity         = Finite 0

    recip (Finite 0)               = OverZero 1
    recip (Finite x)               = Finite (recip x)
    recip (OverPositiveInfinity x) = Undefined
    recip (OverNegativeInfinity _) = Undefined
    recip (OverZero _)             = Undefined
    recip PositiveInfinity         = Finite 0

    fromRational = Finite . fromRational

instance (Ord a) ⇒ Ord (NumberType a) where
    compare (Finite x) (Finite y)       = compare x y
    compare (Finite _) PositiveInfinity = LT

    (Finite x) < (Finite y)       = x < y
    (Finite _) < PositiveInfinity = True

    (Finite x) <= (Finite y)       = x <= y
    (Finite _) <= PositiveInfinity = True

    (Finite x) > (Finite y) = x > y
    (Finite x) >= (Finite y) = x >= y
    max (Finite x) (Finite y) = Finite (max x y)
    min (Finite x) (Finite y) = Finite (min x y)

instance Real a ⇒ Real (NumberType a) where
    toRational (Finite x) = toRational x

-- instance (RealFrac a) => RealFrac (NumberType a) where
--     properFraction (Finite x) :: (a, b) = properFraction x)

main ∷ IO ()
main = do
    print $ Finite 42
    print $ Finite 1 / Finite 0
    print $ Finite 0 / Finite 0
    print $ PositiveInfinity * PositiveInfinity
