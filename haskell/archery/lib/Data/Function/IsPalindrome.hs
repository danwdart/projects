{-# LANGUAGE Safe #-}

module Data.Function.IsPalindrome where

import Control.Category
import Control.Category.Cartesian
import Control.Category.Primitive.Abstract
import Control.Category.Strong
import Prelude                             hiding (id, (.))

isPalindrome ∷ (Category cat, Cartesian cat, Strong cat, Primitive cat) ⇒ cat String Bool
isPalindrome = eq . first' reverseString . copy
