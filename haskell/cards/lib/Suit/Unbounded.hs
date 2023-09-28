module Suit.Unbounded where

import Suit.Class qualified as SuitClass
import Symbol

newtype Suit = Suit Int deriving stock (Eq, Ord, Show)

instance Symbol Suit where
    symbol (Suit 1) = "♠"
    symbol (Suit 2) = "♥"
    symbol (Suit 3) = "♦"
    symbol (Suit 4) = "♣"
    symbol (Suit x) = show x

instance SuitClass.Suit Suit
