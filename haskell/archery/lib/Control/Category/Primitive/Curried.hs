module Control.Category.Primitive.Curried where

class PrimitiveCurried cat where
    eqCurried :: Eq a => cat a (cat a Bool)

instance PrimitiveCurried (->) where
    eqCurried = (==)