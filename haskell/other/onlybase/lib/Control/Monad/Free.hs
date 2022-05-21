module Control.Monad.Free where

data Free f a = Pure a | Free (f (Free f a)) deriving Functor

instance Functor f ⇒ Applicative (Free f) where
    pure = Pure
    Pure a <*> Pure b = Pure $ a b
    Pure a <*> Free f = Free $ fmap a <$> f
    Free f <*> b      = Free $ (<*> b) <$> f

instance Functor f ⇒ Monad (Free f) where
    Pure a >>= f = f a
    Free m >>= f = Free ((>>= f) <$> m)

liftF ∷ Functor f ⇒ f a → Free f a
liftF f = Free (fmap Pure f)

foldFree ∷ Monad m ⇒ (forall x . f x → m x) → Free f a → m a
foldFree _ (Pure a)  = pure a
foldFree f (Free as) = f as >>= foldFree f