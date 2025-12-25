#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/master.zip -p haskell.compiler.ghc914 cabal-install -i cabal
{- cabal:
build-depends: base ^>= 4.22
             , containers ^>=0.8
             , text >=2.1.2
-}
{- project:
packages: *
-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GHC2024 #-}
{-# LANGUAGE UnicodeSyntax #-}

module Main (main) where

import Data.Map     (Map)
import Data.Text    qualified as T
import Data.Text.IO qualified as TIO

g ∷ Map Int Int
g = [(1,1)]

main ∷ IO ()
main = do
    TIO.putStrLn . T.show $ g
    TIO.putStrLn "Hello!"
