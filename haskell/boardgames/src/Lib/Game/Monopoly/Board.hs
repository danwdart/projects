{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Board where

import           Lib.Game.Monopoly.Space

data Board = Board {
    spaces           :: [Space],
    freeParkingMoney :: Int
} deriving (Eq)

instance Show Board where
    show (Board sp fpm) = "Board (spaces: " ++ show (head sp) ++ "Free Parking Money: " ++ show fpm
