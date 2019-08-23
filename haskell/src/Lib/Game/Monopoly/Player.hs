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

data OwnedStatus = Unowned | Owned | Mortgaged

owns :: Player -> Property -> OwnedStatus
owns player property = if property `elem` properties player
    then Owned
    else
        if property `elem` mortgagedProperties player
            then Mortgaged
            else Unowned