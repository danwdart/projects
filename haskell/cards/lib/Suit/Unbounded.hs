module Suit.Unbounded where

import qualified Suit.Class as SuitClass
import           Symbol

newtype Suit = Suit Int deriving (Eq, Ord, Show)

instance Symbol Suit where
    symbol (Suit 1) = "♠"
    symbol (Suit 2) = "♥"
    symbol (Suit 3) = "♦"
    symbol (Suit 4) = "♣"
    symbol (Suit x) = show x

instance SuitClass.Suit Suit
