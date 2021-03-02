#!/usr/bin/env nix-shell
#! nix-shell -i runghc -p haskell.compiler.ghc901

{-# LANGUAGE OverloadedLists #-}

import Data.Map ( Map )

g :: Map Int Int
g = [(1,1)]

main :: IO ()
main = do
    print g
    putStrLn "Hello!"