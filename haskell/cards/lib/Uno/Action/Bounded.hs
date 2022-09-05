module Uno.Action.Bounded where

data Action = DrawTwo | Reverse | Skip deriving (Show, Eq, Ord, Bounded, Enum)