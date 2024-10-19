#!/usr/bin/env nix-shell
#! nix-shell -p "haskell.packages.ghc910.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" -i cabal
{- cabal:
build-depends: base ^>= 4.20
             , containers
-}
{- project:
packages: *
-}
{-# LANGUAGE OverloadedLists #-}

module Main (main) where

import Data.Map ( Map )

g :: Map Int Int
g = [(1,1)]

main :: IO ()
main = do
    print g
    putStrLn "Hello!"