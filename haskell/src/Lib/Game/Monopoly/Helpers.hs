module Lib.Game.Monopoly.Helpers where

import Lib.Game.Monopoly.Board
import Lib.Game.Monopoly.Game
import Lib.Game.Monopoly.Player
import Lib.Game.Monopoly.Space

playerSpace :: [Space] -> Player -> Space
playerSpace spaces player = spaces !! (position player)

processLand :: Player -> Space -> IO Player
processLand player space = do
    return player