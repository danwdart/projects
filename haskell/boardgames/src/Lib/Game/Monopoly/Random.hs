{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Random where

data RandomType = Chance | CommunityChest deriving (Eq)

instance Show RandomType where
    show Chance         = "Chance"
    show CommunityChest = "Community Chest"
