module Control.Category.Apply where

import Control.Arrow (Kleisli(..))

class Apply cat where
    app :: cat (cat a b, a) b

instance Apply (->) where
    app (f, x) = f x

instance Monad m => Apply (Kleisli m) where
    app = Kleisli (\(Kleisli f, x) -> f x)