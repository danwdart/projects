module Seq where

(>>>=) ∷ Monad m ⇒ m b → (b → m a) → m b
a >>>= f = a >>= (\b -> f b >> pure b)
{-# INLINABLE (>>>=) #-}

(>>>) ∷ Monad m ⇒ m b → m a → m b
a >>> f = a >> (f >> a)
{-# INLINABLE (>>>) #-}
