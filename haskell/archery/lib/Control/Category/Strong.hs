{-# LANGUAGE Safe #-}

module Control.Category.Strong where

import Control.Arrow (Kleisli(..))

class Strong cat where
    first' :: cat a b -> cat (a, c) (b, c)
    second' :: cat b c -> cat (a, b) (a, c)

instance Strong (->) where
    first' f (a, b) = (f a, b)
    second' f (a, b) = (a, f b) 

instance Monad m => Strong (Kleisli m) where
    first' (Kleisli f) = Kleisli $ (\(a, c) -> (,c) <$> f a)
    second' (Kleisli f) = Kleisli $ (\(a, b) -> (a,) <$> f b)