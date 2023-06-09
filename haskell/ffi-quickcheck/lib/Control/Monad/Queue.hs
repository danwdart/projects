module Control.Monad.Queue where

import           Control.Monad.Free
import           Control.Monad.Queue.Class
import           Data.Queue

type QueueM t a = Free (QueueF t) a

instance MonadQueue q QueueM a where
    new = liftF NewF
    put q val = liftF (PutF q val)
    get q = liftF (GetF q)
    size q = liftF (SizeF q)

runIO ∷ QueueM q a → IO a
runIO (Free (NewF size next)) = do
    q <- queue_new size
    runIO $ next q
runIO (Free (PutF q val next)) = do
    queue_put q val
    runIO next
runIO (Free (GetF q next)) = do
    val <- queue_get q
    runIO $ next val
runIO (Free (SizeF q next)) = do
    size <- queue_size q
    runIO $ next size
runIO (Pure a) = pure a
