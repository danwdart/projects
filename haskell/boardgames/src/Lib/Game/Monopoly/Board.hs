module Lib.Game.Monopoly.Board where

import Lib.Game.Monopoly.Space

data Board = Board {
    spaces :: [Space],
    freeParkingMoney :: Int
} deriving (Eq)

instance Show Board where
    show (Board spaces freeParkingMoney) = "Board (spaces: " ++ show (spaces !! 0) ++ "Free Parking Money: " ++ show freeParkingMoney