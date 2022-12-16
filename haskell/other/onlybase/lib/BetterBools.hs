module BetterBools where

newtype LightState = LightState Bool

data Lights = Off | On deriving stock (Enum, Eq, Ord, Show)

-- >>> (coerceEnum On :: Bool)
-- True
--

coerceEnum ∷ (Enum a, Enum b) ⇒ a → b
coerceEnum = toEnum . fromEnum
