module Game.Monopoly.Property where

import Game.Monopoly.Addons
import Game.Monopoly.Colour

data Property = Property {
    name       :: String,
    price      :: Int,
    housePrice :: Int,
    colour     :: Colour,
    addons     :: Addons
} deriving stock (Eq)

instance Show Property where
    show (Property n p hp c a) = n <> (" - " <> (show c <> (" (£" <> (show p <> (") (house price: £" <> (show hp <> (") " <> show a)))))))

emptyProperty ∷ Colour → String → Int → Property
emptyProperty c n p = Property {
    name = n,
    price = p,
    housePrice = p `div` 2,
    colour = c,
    addons = NoAddons
}
