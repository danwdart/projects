module BetterBools where

newtype LightState = LightState Bool

data Lights = Off | On deriving (Enum, Eq, Ord, Show)

coerceEnum ∷ (Enum a, Enum b) ⇒ a → b
coerceEnum = toEnum . fromEnum
