module Value.Unbounded where

import Symbol

newtype Value = Value Int deriving (Eq, Ord)

instance Symbol Value where
    symbol (Value 13) = "K"
    symbol (Value 12) = "Q"
    symbol (Value 11) = "J"
    symbol (Value 1)  = "A"
    symbol (Value n)  = show n