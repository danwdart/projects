module Uno.Value.Bounded where

import ANSI

data Value = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine deriving stock (Show, Eq, Ord, Bounded, Enum)

instance ANSI Value where
    renderANSI = show . fromEnum