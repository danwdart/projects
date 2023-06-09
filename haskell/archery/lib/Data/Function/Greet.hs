{-# LANGUAGE DeriveAnyClass, DeriveGeneric, DerivingStrategies, GADTs, OverloadedLists, OverloadedStrings, Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Function.Greet where

import Control.Arrow (Kleisli(..))
import Control.Category
import Control.Category.Cartesian
import Control.Category.Strong
import Control.Category.Symmetric
import Data.Aeson
import Data.ByteString.Lazy.Char8 qualified as BSL
import GHC.Generics
import Prelude hiding ((.), id)
import Data.Function.Free.Abstract
import Data.Code.Haskell.Func
import Data.Code.Haskell.Lamb
import Data.Code.JS.Lamb
import Data.Code.PHP.Lamb
import Data.Text qualified as T

-- First write your datatypes
data Person = Person {
    personName :: String,
    personAge :: Int
} 
    deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

class PrimitiveExtra cat where
    intToString :: cat Int String
    concatString :: cat (String, String) String
    constString :: String -> cat a String

instance PrimitiveExtra (->) where
    intToString = show
    concatString = uncurry (<>)
    constString = const

instance Monad m => PrimitiveExtra (Kleisli m) where
    intToString = Kleisli $ pure . show
    concatString = Kleisli $ pure . uncurry (<>)
    constString s = Kleisli . const . pure $ s

instance PrimitiveExtra HSFunc where
    intToString = "show"
    concatString = "(uncurry (<>))"
    constString s = HSFunc $ "(const \"" <> BSL.pack s <> "\")"

instance PrimitiveExtra HSLamb where
    intToString = "show"
    concatString = "(uncurry (<>))"
    constString s = HSLamb $ "(const \"" <> BSL.pack s <> "\")"

instance PrimitiveExtra JSLamb where
    intToString = "(i => i.toString())"
    concatString = "([a, b]) => a + b"
    constString s = JSLamb $ "(() => \"" <> BSL.pack s <> "\")"

instance PrimitiveExtra PHPLamb where
    intToString = "(fn ($i) => strval($i))"
    concatString = "(fn ([$a, $b]) => $a . $b)"
    constString s = PHPLamb $ "(fn () => \"" <> BSL.pack s <> "\")"

data PrimExtra a b where
    IntToString :: PrimExtra Int String
    ConcatString :: PrimExtra (String, String) String
    ConstString :: String -> PrimExtra a String

-- instance Interpret PrimExtra ()

instance PrimitiveExtra (FreeFunc PrimExtra) where
    intToString = Lift IntToString
    concatString = Lift ConcatString
    constString s = Lift (ConstString s)

instance ToJSON (PrimExtra a b) where
    toJSON IntToString = String "IntToString"
    toJSON ConcatString = String "ConcatString"
    toJSON (ConstString s) = object [ "type" .= ("ConstString" :: T.Text), "args" .= Array [ String (T.pack s) ] ]

instance FromJSON (PrimExtra Int String) where
    parseJSON (String "IntToString") = pure IntToString
    parseJSON _ = fail "TypeError: expecting Int -> String"

instance FromJSON (PrimExtra (String, String) String) where
    parseJSON (String "ConcatString") = pure ConcatString
    parseJSON _ = fail "TypeError: expecting (String, String) -> String"

instance FromJSON (PrimExtra () String) where
    parseJSON = withObject "PrimExtra" $ \obj -> do
        t <- obj .: "type"
        if (t == ("ConstString" :: T.Text)) then do
            Array [ String s ] <- obj .: "args"
            pure $ ConstString (T.unpack s)
        else fail "TypeError: expected () -> String"

-- Then write your primitive classes
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

-- Add your data declarations ready for interpretation
-- @TODO library
-- instance Preload HSFunc PrimitivePerson where
--     preload = "{-# LANGUAGE DeriveAnyClass, DerivingStrategies -#} \n data Person = Person { \n name :: String, \n age :: Int \n } deriving stock (Eq, Show, Generic) \n deriving anyclass (FromJSON, ToJSON)"

-- Implement your primitive class in all functions

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

greetWith :: (Category cat, Cartesian cat, Strong cat, Symmetric cat, PrimitiveExtra cat) => cat a String -> cat a Int -> cat a String
greetWith nameSelector ageSelector = concatString . second' intToString . first' concatString . first' swap . reassoc . second' (second' ageSelector) . second' (first' nameSelector) . first' (constString " is ") . second' copy . copy

greetData :: (Category cat, Cartesian cat, Strong cat, Symmetric cat, PrimitiveExtra cat, PrimitivePerson cat) => cat Person String
greetData = greetWith name age

greetTuple :: (Category cat, Cartesian cat, Strong cat, Symmetric cat, PrimitiveExtra cat) => cat (String, Int) String
greetTuple = greetWith fst' snd'