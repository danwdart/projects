{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-x-partial #-}

module Game.Monopoly.Board where

import Control.Lens
import Game.Monopoly.Space

data Board = Board {
    _spaces           :: [Space],
    _freeParkingMoney :: Int
} deriving stock (Eq)

$(makeClassy ''Board)

instance Show Board where
    show (Board sp fpm) = "Board (spaces: " <> (show (head sp) <> ("Free Parking Money: " <> show fpm))
