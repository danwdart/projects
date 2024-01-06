{-# LANGUAGE DerivingStrategies #-}

module Game.Monopoly.Addons where

data Addons = NoAddons | OneHouse | TwoHouses | ThreeHouses | FourHouses | Hotel deriving stock (Eq, Ord, Enum, Bounded)

instance Show Addons where
    show NoAddons    = "(none)"
    show OneHouse    = "one house"
    show TwoHouses   = "two houses"
    show ThreeHouses = "three houses"
    show FourHouses  = "four houses"
    show Hotel       = "hotel"

addon ∷ Addons → Addons
addon = toEnum . succ . fromEnum
