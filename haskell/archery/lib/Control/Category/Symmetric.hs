{-# LANGUAGE Safe #-}

module Control.Category.Symmetric where

class Symmetric cat where
    swap :: cat (a, b) (b, a)
    swapEither :: cat (Either a b) (Either b a)
    reassoc :: cat (a, (b, c)) ((a, b), c)
    reassocEither :: cat (Either a (Either b c)) (Either (Either a b) c)

instance Symmetric (->) where
    swap (a, b) = (b, a)
    swapEither (Left a)  = Right a
    swapEither (Right a) = Left a
    reassoc (a, (b, c)) = ((a, b), c)
    reassocEither (Left a)          = Left (Left a)
    reassocEither (Right (Left b))  = Left (Right b)
    reassocEither (Right (Right c)) = Right c
