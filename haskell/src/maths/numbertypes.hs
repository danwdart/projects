data NumberType a = Finite a | OverPositiveInfinity a | OverNegativeInfinity a | OverZero a | PositiveInfinity | NegativeInfinity | Undefined | Anything deriving (Eq, Read)

instance (Show a) => Show (NumberType a) where
    show (Finite a) = show a
    show (OverPositiveInfinity a) = show a ++ "/+inf"
    show (OverNegativeInfinity a) = show a ++ "/-inf"
    show (OverZero a) = show a ++ "/0"
    show PositiveInfinity = "+inf"
    show NegativeInfinity = "-inf"
    show Undefined = "undef"
    show Anything = "%*"

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

    PositiveInfinity + PositiveInfinity = PositiveInfinity
    PositiveInfinity - PositiveInfinity = Undefined
    PositiveInfinity * PositiveInfinity = PositiveInfinity
    
    (Finite x) + (Finite y) = Finite (x + y)
    (Finite x) - (Finite y) = Finite (x - y)
    (Finite x) * (Finite y) = Finite (x * y)
    negate (Finite x) = Finite (negate x)
    abs (Finite x) = Finite (abs x)
    signum (Finite x) = Finite (signum x)
    fromInteger = Finite . fromInteger

instance (Fractional a, Eq a) => Fractional (NumberType a) where
    (Finite 0) / (Finite 0) = Anything
    (Finite x) / (Finite 0) = OverZero x
    (Finite x) / (Finite y) = Finite (x/y)
    recip (Finite 0) = OverZero 1
    recip (Finite x) = Finite (recip x)
    fromRational = Finite . fromRational


instance (Ord a) => Ord (NumberType a) where
    compare (Finite x) (Finite y) = compare x y
    (Finite x) < (Finite y) = x < y
    (Finite x) <= (Finite y) = x <= y
    (Finite x) > (Finite y) = x > y
    (Finite x) >= (Finite y) = x >= y
    max (Finite x) (Finite y) = Finite (max x y)
    min (Finite x) (Finite y) = Finite (min x y)
    
main :: IO ()
main = do
    print $ Finite 42
    print $ Finite 1 / Finite 0
    print $ Finite 0 / Finite 0
    print $ PositiveInfinity * PositiveInfinity