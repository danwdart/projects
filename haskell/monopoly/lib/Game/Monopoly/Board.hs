{-# LANGUAGE TemplateHaskell #-}

module Game.Monopoly.Board where

import Data.Lens
import Game.Monopoly.Space

data Board = Board {
    _spaces           :: [Space],
    _freeParkingMoney :: Int
} deriving stock (Eq)

$(makeClassy ''Board)

instance Show Board where
    show (Board sp fpm) = "Board (spaces: " <> (show (head sp) <> ("Free Parking Money: " <> show fpm))