{-# LANGUAGE Safe #-}

module Env.ExtendedInstance where

import Env.Class as Class

data Env = Env {
    a :: String,
    b :: Int,
    c :: (Int, Int)
}

instance Class Env where
    a = Env.ExtendedInstance.a
    b = Env.ExtendedInstance.b