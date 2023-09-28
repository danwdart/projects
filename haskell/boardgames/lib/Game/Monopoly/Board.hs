module Game.Monopoly.Board where

import Game.Monopoly.Space

data Board = Board {
    spaces           :: [Space],
    freeParkingMoney :: Int
} deriving stock (Eq)

instance Show Board where
    show (Board sp fpm) = "Board (spaces: " <> (show (head sp) <> ("Free Parking Money: " <> show fpm))
