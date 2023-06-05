{-# LANGUAGE GADTs, LambdaCase, OverloadedStrings, Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Data.Primitive.Prims where

import Control.Category.Primitive.Abstract
import Control.Category.Primitive.Interpret
import Data.Aeson
import Data.Function.Free.Abstract

data Prims a b where
    ReverseString :: Prims String String
    Equal :: Eq a => Prims (a, a) Bool

deriving instance Show (Prims a b)

instance ToJSON (Prims a b) where
    toJSON ReverseString = String "ReverseString"
    toJSON Equal = String "Equal"

instance FromJSON (Prims String String) where
    parseJSON (String "ReverseString") = pure ReverseString
    parseJSON _ = fail "TypeError: expecting String -> String"

instance Eq a => FromJSON (Prims (a, a) Bool) where
    parseJSON (String "Equal") = pure Equal
    parseJSON _ = fail "TypeError: expecting (a, a) -> Bool"

instance Primitive (FreeFunc Prims) where
    reverseString = Lift ReverseString
    eq = Lift Equal

instance (Primitive cat) => InterpretPrim Prims cat where
    interpretPrim ReverseString = reverseString
    interpretPrim Equal = eq