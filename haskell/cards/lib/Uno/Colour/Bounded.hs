module Uno.Colour.Bounded where

data Colour = Red | Blue | Yellow | Green deriving stock (Show, Eq, Ord, Bounded, Enum)
