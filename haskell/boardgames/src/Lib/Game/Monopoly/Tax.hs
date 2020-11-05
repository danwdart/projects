{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Tax where

data Tax = Tax {
    name :: String,
    price :: Int
} deriving (Eq, Show)

