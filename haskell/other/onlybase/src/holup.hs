{-# OPTIONS_GHC -Wno-x-partial #-}

module Main (main) where

main ∷ IO ()
main = putStrLn holup

holup ∷ String
holup = sequenceA [
    head,
    last,
    last . init,
    foldr (.) id (replicate 9 succ) . last . init . init,
    foldr (.) id (replicate 4 succ) . last . init
    ] "Hello"
