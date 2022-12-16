module Uno.Value.Bounded where

data Value = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine deriving stock (Show, Eq, Ord, Bounded, Enum)
