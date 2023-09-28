{-# LANGUAGE DeriveAnyClass #-}
{-# OPTIONS_GHC -Wno-missing-methods #-}

import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer

newtype MyThing a = MyThing {
    runMyThing :: a
}
    deriving stock (Functor)
    deriving anyclass (Applicative, Monad, MonadState s, MonadWriter w, MonadReader r)


foo ∷ (MonadState Int m, MonadWriter [String] m, MonadReader () m) ⇒ m String
foo = do
    put (1 :: Int)
    tell ["Hi"]
    ask
    pure "Hi"

main ∷ IO ()
main = print $ runMyThing foo
