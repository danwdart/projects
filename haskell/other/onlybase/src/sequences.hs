module Main (main) where

import Sequences

main ∷ IO ()
main = print [
    fibonacci !! (5 :: Int),
    lucas !! (5 :: Int)
    ]
