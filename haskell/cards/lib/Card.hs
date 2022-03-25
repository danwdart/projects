{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UnicodeSyntax     #-}

module Card where

import           Data.Char
import qualified Suit.Bounded.Standard  as SuitStandard
import qualified Suit.Unbounded         as SuitUnbounded
import           Symbol
import qualified Value.Bounded.Standard as ValueStandard
import qualified Value.Unbounded        as ValueUnbounded

data Card value suit = Card {
    value :: value,
    suit  :: suit
} deriving (Eq, Show)

unicodeOffset, unicodeSuitMultiplier ∷ Int
unicodeOffset = 0x1f0a1
unicodeSuitMultiplier = 0x10

{-
-- Original
instance (Show v, Show s) => Show (Card v s) where
    show (Card v s) = show v <> show s
-}

instance Symbol (Card ValueStandard.Value SuitStandard.Suit) where
    symbol (Card value' suit') =
        [chr $
            unicodeOffset +
            unicodeSuitMultiplier * fromEnum suit' +
            fromEnum value' +
            -- in Unicode, a "Knight" exists between Jack and Queen: 🂬🂼🃌🃜
            if value' > ValueStandard.Jack then 1 else 0
        ]

instance Symbol (Card ValueUnbounded.Value SuitUnbounded.Suit) where
    symbol (Card (ValueUnbounded.Value value') (SuitUnbounded.Suit suit')) =
        [chr $
            unicodeOffset +
            unicodeSuitMultiplier * (suit' - 1) +
            value' - 1 +
            -- in Unicode, a "Knight" exists between Jack and Queen: 🂬🂼🃌🃜
            if value' > 11 then 1 else 0
        ]
