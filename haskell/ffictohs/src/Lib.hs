{-# LANGUAGE CApiFFI #-}

module Lib where

lib :: IO ()
lib = putStrLn "Hello from Haskell!"

foreign export capi lib :: IO ()