#!/usr/bin/env nix-shell
#! nix-shell -p haskell.compiler.ghc92 -i runghc

{-# LANGUAGE OverloadedLists #-}

import Data.Map ( Map )

g :: Map Int Int
g = [(1,1)]

main :: IO ()
main = do
    print g
    putStrLn "Hello!"