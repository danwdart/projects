{-# LANGUAGE Safe #-}

module Control.Category.Numeric where

import Control.Arrow (Kleisli(..))

class Numeric cat where
    num :: Int → cat a Int
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

instance Monad m => Numeric (Kleisli m) where
    num n = Kleisli . const . pure $ n
    negate' = Kleisli $ pure . negate
    add = Kleisli $ pure . uncurry (+)
    mult = Kleisli $ pure . uncurry (*)
    div' = Kleisli $ pure . uncurry div
    mod' = Kleisli $ pure . uncurry mod