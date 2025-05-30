#!/usr/bin/env nix-shell
#! nix-shell -p haskell.compiler.ghc912 stack -i stack
-- stack --resolver nightly-2020-12-03 script

{-# LANGUAGE OverloadedLists #-}

module Main (main) where

import Data.Map ( Map )

g :: Map Int Int
g = [(1,1)]

main :: IO ()
main = do
    print g
    putStrLn "Hello!"