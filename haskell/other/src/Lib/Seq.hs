module Lib.Seq where

(>>>=) :: Monad m => m b -> (b -> m a) -> m b
a >>>= f = a >>= (\b -> f b >> return b)