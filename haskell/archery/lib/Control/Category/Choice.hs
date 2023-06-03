{-# LANGUAGE Safe #-}

module Control.Category.Choice where

class Choice cat where
    left' :: cat a b -> cat (Either a x) (Either b x)
    right' :: cat a b -> cat (Either x a) (Either x b)

instance Choice (->) where
    left' f (Left a) = Left (f a)
    left' _ (Right a) = Right a
    right' _ (Left a) = Left a
    right' f (Right a) = Right (f a)

-- instance Monad m => Choice (Kleisli m) where