{-# LANGUAGE Safe #-}

module Env.Instance where

import Env.Class as Class

data Env = Env {
    a :: String,
    b :: Int
}

instance Class Env where
    a = Env.Instance.a
    b = Env.Instance.b