#!/usr/bin/env nix-shell
#! nix-shell -p haskell.compiler.ghc912 cabal-install -i cabal
{- cabal:
build-depends: base ^>= 4.21
             , containers ^>=0.8.0
             , text >=2.1.2
-}
{- project:
packages: *
-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

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
