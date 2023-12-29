module Game.Monopoly.Random where

data RandomType = Chance | CommunityChest deriving stock (Eq)

instance Show RandomType where
    show Chance         = "Chance"
    show CommunityChest = "Community Chest"
