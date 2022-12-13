{-# LANGUAGE Safe #-}

module Env.Class where

class Class clinst where
    a :: clinst -> String
    b :: clinst -> Int