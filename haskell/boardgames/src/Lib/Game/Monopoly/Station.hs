{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Station where

stationPrice ∷ Int
stationPrice = 200

newtype Station = Station {
    name :: String
} deriving (Eq, Show)
