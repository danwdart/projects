{-# LANGUAGE DerivingStrategies #-}

module Control.Exception.RangeException (RangeException(..)) where

import Control.Exception
import Data.Typeable

data RangeException a = NumberTooBig a | NumberTooSmall a
    deriving stock (Show)

instance (Show a, Typeable a) => Exception (RangeException a)
