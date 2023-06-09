{-# LANGUAGE GADTs, OverloadedStrings #-}

module Data.Primitive.PrimPerson where

import Control.Category.Primitive.Person
import Data.Aeson
import Data.Person
import Data.Function.Free.Abstract

data PrimPerson a b where
    Name :: PrimPerson Person String
    Age :: PrimPerson Person Int

instance PrimitivePerson (FreeFunc PrimPerson) where
    name = Lift Name
    age = Lift Age

instance ToJSON (PrimPerson a b) where
    toJSON Name = String "Name"
    toJSON Age = String "Age"

instance FromJSON (PrimPerson Person String) where
    parseJSON (String "Name") = pure Name
    parseJSON _ = fail "TypeError: expecting Person -> String"

instance FromJSON (PrimPerson Person Int) where
    parseJSON (String "Age") = pure Age
    parseJSON _ = fail "TypeError: expecting Person -> Int"