{-# LANGUAGE DeriveAnyClass   #-}
{-# LANGUAGE DeriveFunctor    #-}
{-# LANGUAGE FlexibleContexts #-}

import           Control.Monad.Cont
import           Control.Monad.Except
import           Control.Monad.Identity
import           Control.Monad.IO.Class
import           Control.Monad.Reader
import           Control.Monad.State
import           Control.Monad.Trans
import           Control.Monad.Writer

newtype MyThing a = MyThing {
    runMyThing :: a
} deriving (Functor, Applicative, Monad, MonadState s, MonadWriter w, MonadReader r)


foo :: (MonadState Int m, MonadWriter [String] m, MonadReader () m) => m String
foo = do
    put (1 :: Int)
    tell ["Hi"]
    ask
    return "Hi"

main :: IO ()
main = print $ runMyThing foo
