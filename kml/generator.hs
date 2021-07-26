#!/usr/bin/env nix-shell
#! nix-shell -p haskell.compiler.ghc901 -i runhaskell

main :: IO ()
main = putStrLn
    "line 1\n\
    \line 2\n\
    \line 3"