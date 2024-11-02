{-# LANGUAGE Safe, NoGeneralisedNewtypeDeriving, UnicodeSyntax #-}

module BetterBools where

newtype LightState = LightState Bool

data Lights = Off | On deriving stock (Enum, Eq, Ord, Show)

data BoolyThing
data OtherBoolyThing

newtype Booly a = Booly Bool deriving stock (Eq, Ord, Show)

-- >>> Booly True :: Booly BoolyThing
-- Booly True
--

-- >>> Booly False :: Booly OtherBoolyThing
-- Booly False
--

-- >>> (coerceEnum On :: Bool)
-- True
--

coerceEnum ∷ (Enum a, Enum b) ⇒ a → b
coerceEnum = toEnum . fromEnum
