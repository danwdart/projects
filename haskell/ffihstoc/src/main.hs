{-# LANGUAGE CApiFFI #-}

module Main where

foreign import capi lib :: IO ()

main :: IO ()
main = do
    putStrLn "Hello from Haskell!"
    lib
