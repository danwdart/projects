{-# LANGUAGE OverloadedStrings #-}

module Control.Category.Primitive.Person where

import Data.Code.Haskell.Func
import Data.Code.Haskell.Lamb
import Data.Code.JS.Lamb
import Data.Code.PHP.Lamb
import Data.Person

class PrimitivePerson cat where
    name :: cat Person String
    age :: cat Person Int

instance PrimitivePerson (->) where
    name = personName
    age = personAge

{-}
instance Monad m => PrimitivePerson (Kleisli m) where
    name (Kleisli person) = Kleisli . pure . personName $ person
    age (Kleisli person) = Kleisli . pure . personAge $ person
-}

-- @TODO orphan these
instance PrimitivePerson HSFunc where
    name = "name"
    age = "age"

instance PrimitivePerson HSLamb where
    name = "name"
    age = "age"

instance PrimitivePerson JSLamb where
    name = "(person => person.name)"
    age = "(person => person.age)"

instance PrimitivePerson PHPLamb where
    name = "(fn ($person) => $person['name'])"
    age = "(fn ($person) => $person['age'])"
