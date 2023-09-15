module Uno.Wild.Bounded where

import ANSI

data Wild = Wild | WildShuffleHands | WildDrawFour | WildCustomisable deriving stock (Show, Eq, Ord, Bounded, Enum)
        --  x4     x1                 x4             x3

instance ANSI Wild where
    renderANSI Wild = "Wild"
    renderANSI WildShuffleHands = "Shuffle Hands"
    renderANSI WildDrawFour = "+4"
    renderANSI WildCustomisable = "?"