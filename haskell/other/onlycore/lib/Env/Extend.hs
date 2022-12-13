{-# LANGUAGE Safe #-}

module Env.Extend where

data Env = Env {
    a :: String,
    b :: Int,
    c :: (Int, Int)
}
