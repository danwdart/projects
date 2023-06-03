{-# LANGUAGE GADTs, OverloadedStrings, Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Primitive.Prims where

import Control.Category.Primitive.Abstract
import Data.Aeson
import Data.Function.Free.Abstract

data Prims a b where
    ReverseString :: Prims String String
    Equal :: Eq a => Prims (a, a) Bool

deriving instance Show (Prims a b)

instance ToJSON (Prims a b) where
    toJSON ReverseString = String "ReverseString"
    toJSON Equal = String "Equal"

instance Primitive (FreeFunc Prims) where
    reverseString = Lift ReverseString
    eq = Lift Equal