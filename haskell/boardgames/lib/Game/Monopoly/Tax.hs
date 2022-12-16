module Game.Monopoly.Tax where

data Tax = Tax {
    name  :: String,
    price :: Int
} deriving stock (Eq, Show)

