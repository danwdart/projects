module Lib.Game.Monopoly.Player where

import Lib.Game.Monopoly.Property
import Lib.Game.Monopoly.Token

data Player = Player {
    name :: String,
    token :: Token,
    position :: Int,
    money :: Int,
    properties :: [Property],
    mortgagedProperties :: [Property]
} deriving (Eq, Show)

newPlayer :: String -> Token -> Player
newPlayer name token = Player name token 0 1500 [] []
