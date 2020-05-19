{-# LANGUAGE UnicodeSyntax #-}
module Lib.Game.Monopoly.Colour where

data Colour = Brown | LightBlue | Pink | Orange | Red | Yellow | Green | DarkBlue deriving (Eq)

instance Show Colour where
    show Brown     = "Brown"
    show LightBlue = "Light Blue"
    show Pink      = "Pink"
    show Orange    = "Orange"
    show Red       = "Red"
    show Yellow    = "Yellow"
    show Green     = "Green"
    show DarkBlue  = "Dark Blue"
