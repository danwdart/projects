module Suit.Bounded.Standard where

import Suit.Class qualified as SuitClass
import Symbol

data Suit = Spades | Hearts | Diamonds | Clubs
    deriving stock (Bounded, Enum, Eq, Ord, Show)

instance Symbol Suit where
    symbol Spades   = "♠"
    symbol Hearts   = "♥"
    symbol Diamonds = "♦"
    symbol Clubs    = "♣"

instance SuitClass.Suit Suit
