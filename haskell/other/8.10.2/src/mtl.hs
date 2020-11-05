{-# LANGUAGE DeriveAnyClass   #-}
{-# LANGUAGE DeriveFunctor    #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE UnicodeSyntax    #-}
{-# OPTIONS_GHC -Wno-missing-methods #-}

import           Control.Monad.Reader
import           Control.Monad.State
import           Control.Monad.Writer

newtype MyThing a = MyThing {
    runMyThing :: a
} deriving (Functor, Applicative, Monad, MonadState s, MonadWriter w, MonadReader r)


foo ∷ (MonadState Int m, MonadWriter [String] m, MonadReader () m) ⇒ m String
foo = do
    put (1 :: Int)
    tell ["Hi"]
    ask
    return "Hi"

main ∷ IO ()
main = print $ runMyThing foo
