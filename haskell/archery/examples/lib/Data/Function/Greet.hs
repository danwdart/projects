{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GADTs              #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE Unsafe             #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Function.Greet where

import Control.Arrow                     (Kleisli (..))
import Control.Category
import Control.Category.Cartesian
import Control.Category.Primitive.Extra
import Control.Category.Primitive.Person
import Control.Category.Strong
import Control.Category.Symmetric
import Data.Aeson
import Data.Code.Haskell.Func
import Data.Code.Haskell.Lamb
import Data.Code.JS.Lamb
import Data.Code.PHP.Lamb
import Data.Function.Free.Abstract
import Data.Person
import GHC.Generics
import Prelude                           hiding (id, (.))

greetWith ∷ (Category cat, Cartesian cat, Strong cat, Symmetric cat, PrimitiveExtra cat) ⇒ cat a String → cat a Int → cat a String
greetWith nameSelector ageSelector = concatString . second' intToString . first' concatString . first' swap . reassoc . second' (second' ageSelector) . second' (first' nameSelector) . first' (constString " is ") . second' copy . copy

greetData ∷ (Category cat, Cartesian cat, Strong cat, Symmetric cat, PrimitiveExtra cat, PrimitivePerson cat) ⇒ cat Person String
greetData = greetWith name age

greetTuple ∷ (Category cat, Cartesian cat, Strong cat, Symmetric cat, PrimitiveExtra cat) ⇒ cat (String, Int) String
greetTuple = greetWith fst' snd'
