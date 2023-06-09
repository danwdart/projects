module Control.Monad.Queue.Class where

class MonadQueue q m where
    new :: Int → m q
    put :: q → Int → m ()
    get :: q → m Int
    size :: q → m Int
