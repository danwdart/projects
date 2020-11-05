{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Token where

data Token = Dog | TopHat | Wheelbarrow | RacingCar | Boot | Iron | Battleship | Thimble deriving (Eq)

instance Show Token where
    show Dog = "Dog"
    show TopHat = "Top Hat"
    show Wheelbarrow = "Wheelbarrow"
    show RacingCar = "Racing Car"
    show Boot = "Boot"
    show Iron = "Iron"
    show Battleship = "Battleship"
    show Thimble = "Thimble"
