{-# LANGUAGE LambdaCase #-}

module Value.Bounded.Number where

import           Symbol

data NumValue = Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten
    deriving stock (Bounded, Enum, Eq, Ord, Show)

instance Symbol NumValue where
    symbol = \case
        Two   -> "2"
        Three -> "3"
        Four  -> "4"
        Five  -> "5"
        Six   -> "6"
        Seven -> "7"
        Eight -> "8"
        Nine  -> "9"
        Ten   -> "10"
