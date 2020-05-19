{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Utility where

utilityPrice ∷ Int
utilityPrice = 150

data Utility = Utility {
    name :: String
} deriving (Eq, Show)
