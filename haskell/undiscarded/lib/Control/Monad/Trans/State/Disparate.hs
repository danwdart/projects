{-# LANGUAGE UnicodeSyntax #-}
module Control.Monad.Trans.State.Disparate where

newtype StateDisparateT s1 s2 m a = StateDisparateT (s1 → m (a, s2))

newtype StateDoubleT s1 s2 m a = StateDoubleT (s1 → s2 → m (a, (s1, s2)))
