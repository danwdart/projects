module Game.Monopoly.Game where

import           Game.Monopoly.Board
import           Game.Monopoly.Player
import           Game.Monopoly.Rules

data Game = Game {
    board   :: Board,
    players :: [Player],
    rules   :: Rules
} deriving (Eq, Show)
