module Uno.Action.Bounded where

data Action = DrawTwo | Reverse | Skip deriving stock (Show, Eq, Ord, Bounded, Enum)
