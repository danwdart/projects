module Lib.Game.Monopoly.Property where

import Lib.Game.Monopoly.Addons
import Lib.Game.Monopoly.Colour

data Property = Property {
    name :: String,
    price :: Int,
    housePrice :: Int,
    colour :: Colour,
    addons :: Addons
} deriving (Eq)

instance Show Property where
    show (Property n p hp c a) = n ++ " - " ++ show c ++ " (£" ++ show p ++ ") (house price: £" ++ show hp ++ ") "++ show a

emptyProperty :: Colour -> String -> Int -> Property
emptyProperty colour name price = Property {
    name = name,
    price = price,
    housePrice = price `div` 2,
    colour = colour,
    addons = NoAddons
}