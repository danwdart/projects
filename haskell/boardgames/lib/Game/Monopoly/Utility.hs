module Game.Monopoly.Utility where

utilityPrice ∷ Int
utilityPrice = 150

newtype Utility = Utility {
    name :: String
} deriving stock (Eq, Show)
