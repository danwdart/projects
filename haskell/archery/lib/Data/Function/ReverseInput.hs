{-# LANGUAGE Safe #-}

module Data.Function.ReverseInput where

import Control.Category
import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Console
import Prelude                             hiding (id, (.))

revInputProgram ∷ (Category cat, PrimitiveConsole cat, Primitive cat) ⇒ cat () ()
revInputProgram = outputString . reverseString . inputString
