module Main (main) where

import Sequences

main ∷ IO ()
main = print [
    case drop (5 :: Int) fibonacci of
  x : _ -> x
  []    -> error _,
    case drop (5 :: Int) lucas of
  x : _ -> x
  []    -> error _
    ]
