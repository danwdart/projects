{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Game where

import           Lib.Game.Monopoly.Board
import           Lib.Game.Monopoly.Player
import           Lib.Game.Monopoly.Rules

data Game = Game {
    board :: Board,
    players :: [Player],
    rules :: Rules
} deriving (Eq, Show)
