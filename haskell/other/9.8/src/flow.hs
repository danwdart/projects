module Main (main) where

import Flow

main ∷ IO ()
main = do
    (1 :: Int) |> (+ 2) |> (+ 3) |> print
    print <| (+ 3) <| (+ 2) <| (1 :: Int)
    print <| (+ 2) .> (+ 3) <| (3 :: Int)
    print <| (+ 2) <. (+ 3) <| (3 :: Int)
    (3 :: Int) |> (+ 2) <. (+ 1) |> print
    (3 :: Int) |> (+ 2) .> (+ 1) |> print
