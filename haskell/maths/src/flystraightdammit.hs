{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import Data.List.Index

numbers :: [Integer]
numbers = go [1,1] where
    go :: [Integer] -> [Integer]
    go xs = 1:go xs

main :: IO ()
main = pure ()