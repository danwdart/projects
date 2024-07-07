{-| Number trees.
-}
module Numeric.Tree where

-- >>> 3 + 4 * 8 :: Expr
data Expr =
    FromInteger Integer |
    Add Expr Expr |
    Sub Expr Expr |
    Mul Expr Expr |
    Negate Expr |
    Abs Expr |
    Signum Expr
    deriving stock (Eq, Show) -- equal structure not unique value necessarily

instance Num Expr where
    (+) = Add
    (-) = Sub
    (*) = Mul
    negate = Negate
    abs = Abs
    signum = Signum
    fromInteger = fromInteger

-- ppr -> in a way
