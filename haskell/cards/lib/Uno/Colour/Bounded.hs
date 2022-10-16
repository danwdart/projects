module Uno.Colour.Bounded where

data Colour = Red | Blue | Yellow | Green deriving (Show, Eq, Ord, Bounded, Enum)
