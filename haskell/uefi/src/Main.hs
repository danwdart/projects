module Main where

main :: IO ()
main = putStrLn "Hello, Haskell!"

foreign export capi main :: IO ()