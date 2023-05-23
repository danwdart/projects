module Control.Monad.Free where

data Free f a = Free (f (Free f a)) | Pure a

liftF :: Functor f => f a -> Free f a
liftF action = Free (fmap Pure action)
