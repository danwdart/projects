{-# LANGUAGE Safe #-}

module Env.AbstractExtension where

data Env orig = Env {
    orig :: orig,
    c :: (Int, Int)
} deriving stock (Eq, Show)