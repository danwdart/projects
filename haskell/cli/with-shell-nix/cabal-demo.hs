#!/usr/bin/env cabal
{- cabal:
build-depends: base ^>= 4.21
             , containers >=0.8
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