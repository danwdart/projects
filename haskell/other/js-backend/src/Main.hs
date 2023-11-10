module Main (main) where

import MyLib qualified (someFunc)

main ∷ IO ()
main = do
  putStrLn "Hello, Haskell!"
  MyLib.someFunc
