{-# LANGUAGE Safe #-}

module Data.Function.CollatzStep where

import Control.Category
-- import Control.Category.Execute.Haskell
import Control.Category.Numeric
import Control.Category.Cartesian
import Control.Category.Cocartesian
import Control.Category.Choice
import Control.Category.Strong
import Control.Category.Primitive.Abstract
import Control.Category.Utilities
import Prelude hiding ((.), id)

collatzStep :: forall cat. (Category cat, Numeric cat, Cartesian cat, Cocartesian cat, Choice cat, Strong cat, Primitive cat) => cat Int Int
collatzStep = unify . (onOdds +++ onEvens) . matchOn isEven where
    onOdds :: cat Int Int
    onOdds = strong add (num 1) . strong mult (num 3)

    onEvens :: cat Int Int
    onEvens = strong div' (num 2)

    isEven :: cat Int Bool
    isEven = strong eq (num 0) . mod2

    mod2 :: cat Int Int
    mod2 = strong mod' (num 2)

    matchOn :: cat a Bool -> cat a (Either a a)
    matchOn predicate = tag . first' predicate . copy
