{-# LANGUAGE DeriveAnyClass, DeriveGeneric, DerivingStrategies #-}

module Data.Person where

import Data.Aeson
import GHC.Generics

data Person = Person {
    personName :: String,
    personAge :: Int
} 
    deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)