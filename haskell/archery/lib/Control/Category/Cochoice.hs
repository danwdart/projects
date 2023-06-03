module Control.Category.Cochoice where

class Cochoice cat where
    unleft :: cat (Either a c) (Either b c) -> cat a b

instance Cochoice (->) where
    unleft :: forall a b c. (Either a c -> Either b c) -> a -> b
    unleft f a = case f (Left a) of
        Left b -> b
        Right c -> goRight c where
            goRight :: c -> b
            goRight c' = case f (Right c') of
                Left b -> b
                Right c'' -> goRight c''

-- instance Monad m => Cochoice (Kleisli m) where