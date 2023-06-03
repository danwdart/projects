{-# LANGUAGE Safe #-}

module Control.Category.Primitive.Abstract where

import Control.Arrow (Kleisli(..))

class Primitive cat where
    eq :: Eq a => cat (a, a) Bool
    reverseString :: cat String String

instance Primitive (->) where
    eq = uncurry (==)
    reverseString = reverse

instance Monad m => Primitive (Kleisli m) where
    eq = Kleisli (pure . eq)
    reverseString = Kleisli (pure . reverseString)