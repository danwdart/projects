module Main (main) where

import MyLib qualified (someFunc)

main ∷ IO ()
main = do
  putStrLn "Hello from Haskell! Now injecting hello into the global namespace..."
  MyLib.someFunc
