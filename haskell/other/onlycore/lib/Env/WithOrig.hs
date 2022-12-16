{-# LANGUAGE Safe #-}

module Env.WithOrig where

import Env.Env as Orig

data Env = Env {
    orig :: Orig.Env,
    c :: (Int, Int)
} deriving stock (Eq, Show)