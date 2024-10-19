#!/usr/bin/env nix-shell
#! nix-shell -p "haskell.packages.ghc910.ghcWithPackages (pkgs: with pkgs; [ containers ])" -i runghc

{-# LANGUAGE OverloadedLists #-}

module Main (main) where

import Data.Map ( Map )

g :: Map Int Int
g = [(1,1)]

main :: IO ()
main = do
    print g
    putStrLn "Hello!"