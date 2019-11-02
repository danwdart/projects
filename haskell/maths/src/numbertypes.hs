data NumberType a = Finite a |
    OverPositiveInfinity a |
    OverNegativeInfinity a |
    OverZero a |
    PositiveInfinity |
    NegativeInfinity |
    Undefined |
    Anything deriving (Eq, Read)

instance (Show a) => Show (NumberType a) where
    show (Finite a) = show a
    show (OverPositiveInfinity a) = show a ++ "/+inf"
    show (OverNegativeInfinity a) = show a ++ "/-inf"
    show (OverZero a) = show a ++ "/0"
    show PositiveInfinity = "+inf"
    show NegativeInfinity = "-inf"
    show Undefined = "undef"
    show Anything = "%*"

{-}
instance (Num a) => Num (NumberType a) where
    -- (Finite a) + PositiveInfinity = PositiveInfinity
    -- PositiveInfinity + (Finite a) = PositiveInfinity

    -- (Finite a) - PositiveInfinity = NegativeInfinity
    -- PositiveInfinity - (Finite a) = PositiveInfinity

    -- (Finite a) * PositiveInfinity = PositiveInfinity
    -- PositiveInfinity * (Finite a) = PositiveInfinity

    -- negate PositiveInfinity = NegativeInfinity
    -- negate NegativeInfinity = PositiveInfinity

    --abs PositiveInfinity = PositiveInfinity
    -- abs NegativeInfinity = PositiveInfinity

    -- signum PositiveInfinity = 1
    -- signum NegativeInfinity = -1

    -- PositiveInfinity + PositiveInfinity = PositiveInfinity
    -- PositiveInfinity - PositiveInfinity = Undefined
    -- PositiveInfinity * PositiveInfinity = PositiveInfinity

    (Finite x) + (OverPositiveInfinity y) = Undefined
    (Finite x) + (OverNegativeInfinity y) = Undefined
    (Finite x) + (OverZero y) = Undefined
    (Finite x) + PositiveInfinity = Undefined

    (Finite x) - (OverPositiveInfinity y) = Undefined
    (Finite x) - (OverNegativeInfinity y) = Undefined
    (Finite x) - (OverZero y) = Undefined
    (Finite x) - PositiveInfinity = Undefined

    (Finite x) * (OverPositiveInfinity y) = Undefined
    (Finite x) * (OverNegativeInfinity y) = Undefined
    (Finite x) * (OverZero y) = Undefined
    (Finite x) * PositiveInfinity = Undefined
    
    (Finite x) + (Finite y) = Finite (x + y)
    (Finite x) - (Finite y) = Finite (x - y)
    (Finite x) * (Finite y) = Finite (x * y)
    
    negate (Finite x) = Finite (negate x)
    negate (OverPositiveInfinity _) = Undefined
    negate (OverNegativeInfinity _) = Undefined
    negate (OverZero _) = Undefined
    negate PositiveInfinity = NegativeInfinity

    abs (Finite x) = Finite (abs x)
    abs (OverPositiveInfinity _) = Undefined
    abs (OverNegativeInfinity _) = Undefined
    abs (OverZero _) = Undefined
    abs PositiveInfinity = PositiveInfinity

    signum (Finite x) = signum x
    signum (OverPositiveInfinity _) = Undefined
    signum (OverNegativeInfinity _) = Undefined
    signum (OverZero _) = Undefined
    signum PositiveInfinity = 1

    fromInteger = Finite . fromInteger

instance (Fractional a, Eq a) => Fractional (NumberType a) where
    (Finite 0) / (Finite 0) = Anything
    (Finite x) / (Finite 0) = OverZero x
    (Finite x) / (Finite y) = Finite (x/y)
    (Finite p) / (OverPositiveInfinity _) = Undefined
    (Finite p) / (OverNegativeInfinity _) = Undefined
    (Finite p) / (OverZero _) = Undefined
    (Finite p) / PositiveInfinity = Finite 0

    recip (Finite 0) = OverZero 1
    recip (Finite x) = Finite (recip x)
    recip (OverPositiveInfinity x) = Undefined
    recip (OverNegativeInfinity _) = Undefined
    recip (OverZero _) = Undefined
    recip PositiveInfinity = Finite 0

    fromRational = Finite . fromRational

{-}
instance (Ord a) => Ord (NumberType a) where
    compare (Finite x) (Finite y) = compare x y
    compare (Finite _) (OverPositiveInfinity _) = undefined
    compare (Finite _) (OverNegativeInfinity _) = undefined
    compare (Finite _) (OverZero _) = undefined
    compare (Finite _) PositiveInfinity = LT


    (Finite x) < (Finite y) = x < y
    (Finite _) < (OverPositiveInfinity _) = undefined
    (Finite _) < (OverNegativeInfinity _) = undefined
    (Finite _) < (OverZero _) = undefined
    (Finite _) < PositiveInfinity = True

    (Finite x) <= (Finite y) = x <= y
    (Finite _) <= (OverPositiveInfinity _) = undefined
    (Finite _) <= (OverNegativeInfinity _) = undefined
    (Finite _) <= (OverZero _) = undefined
    (Finite _) <= PositiveInfinity = True

    (Finite x) > (Finite y) = x > y
    (Finite x) >= (Finite y) = x >= y
    max (Finite x) (Finite y) = Finite (max x y)
    min (Finite x) (Finite y) = Finite (min x y)
-}
main :: IO ()
main = do
    print $ Finite 42
    print $ Finite 1 / Finite 0
    print $ Finite 0 / Finite 0
    print $ PositiveInfinity * PositiveInfinity
-}

main :: IO ()
main = undefined