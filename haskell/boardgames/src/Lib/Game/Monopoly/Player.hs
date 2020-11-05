{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Player where

import           Lib.Game.Monopoly.Property
import           Lib.Game.Monopoly.Token

data Player = Player {
    name :: String,
    token :: Token,
    position :: Int,
    money :: Int,
    properties :: [Property],
    mortgagedProperties :: [Property]
} deriving (Eq, Show)

newPlayer ∷ String → Token → Player
newPlayer n t = Player n t 0 1500 [] []

data OwnedStatus = Unowned | Owned | Mortgaged

owns ∷ Player → Property → OwnedStatus
owns player property
  | property `elem` properties player = Owned
  | property `elem` mortgagedProperties player = Mortgaged
  | otherwise = Unowned
