module Player where

import Data.Data

data Player = Player {
    name     :: String,
    position :: Int,
    money    :: Int
} deriving stock (Data, Show)
