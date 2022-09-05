module Uno.Wild.Bounded where

data Wild = Wild | WildShuffleHands | WildDrawFour | WildCustomisable deriving (Show, Eq, Ord, Bounded, Enum)
        --  x4     x1                 x4             x3