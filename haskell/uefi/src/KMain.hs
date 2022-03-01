{-# LANGUAGE CApiFFI #-}

module KMain where

kmain :: IO ()
kmain = putStrLn "Hello, Haskell!"

foreign export capi kmain :: IO ()