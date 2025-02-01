#!/usr/bin/env nix-shell
#! nix-shell -p "haskell.packages.ghc910.ghcWithPackages (pkgs: with pkgs; [ containers text ])" -i runghc

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
