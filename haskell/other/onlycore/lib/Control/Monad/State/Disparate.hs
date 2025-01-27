{-# LANGUAGE Safe #-}

module Control.Monad.State.Disparate where

import Control.Monad.Identity
import Control.Monad.State.Disparate

type StateDisparate s1 s2 = StateDisparateT s1 s2 Identity

type StateDouble s1 s2 = StateDoubleT s1 s2 Identity
