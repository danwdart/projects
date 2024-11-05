{-# LANGUAGE DeriveAnyClass #-}

module Control.Exception.RangeException (RangeException(..)) where

import Control.Exception

data RangeException a = NumberTooBig a | NumberTooSmall a
    deriving stock (Show)
    deriving anyclass (Exception)
