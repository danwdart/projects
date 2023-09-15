module Uno.Action.Bounded where

import ANSI

data Action = DrawTwo | Reverse | Skip deriving stock (Show, Eq, Ord, Bounded, Enum)

instance ANSI Action where
    renderANSI DrawTwo = "+2"
    renderANSI Reverse = "⟳" -- eh
    renderANSI Skip = "⊘"