module Control.Category.Numeric where

class Numeric cat where
    num :: Int -> cat a Int
    negate' :: cat Int Int
    add :: cat (Int, Int) Int
    mult :: cat (Int, Int) Int
    div' :: cat (Int, Int) Int
    mod' :: cat (Int, Int) Int

instance Numeric (->) where
    num = const
    negate' = negate
    add = uncurry (+)
    mult = uncurry (*)
    div' = uncurry div
    mod' = uncurry mod