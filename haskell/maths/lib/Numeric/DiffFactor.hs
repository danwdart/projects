{-| Seems to be some kind of number-purpose library at the moment.
 -|
 -}
module Numeric.DiffFactor where

-- >>> Diff 5 + Factor 7 * Normal 2
data DiffFactor a = Normal a | Diff a | Factor a
    deriving (Eq, Show) -- maybe inverse

instance Num a => Num (DiffFactor a) where
    Normal a + Diff b = Normal (a + b)
    Diff a + Normal b = Normal (a + b)
    _ + _ = error "can't add a [t] to a [s]"
    Normal a * Factor b = Normal (a * b)
    Factor a * Normal b = Normal (a * b)
    _ * _ = error "can't mu;tiply a [t] to a [s]"
    abs (Normal a) = Normal (abs a)
    abs _ = error "can't abs a non-normal value"
    signum (Normal a) = Normal (signum a)
    signum _ = error "can't signum a non-normal value"
    fromInteger a = Normal (fromInteger a)
    negate (Normal a) = Normal (negate a)