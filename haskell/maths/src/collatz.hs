module Main (main) where

import Collatz

main ∷ IO ()
main = print $ chain 89
