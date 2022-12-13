{-# LANGUAGE Safe #-}

module Env.Env where

data Env = Env {
    a :: String,
    b :: Int
} deriving (Eq, Show)