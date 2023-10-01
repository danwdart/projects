{-# LANGUAGE Safe #-}

module Computer where

import Data.Data

type Make = String
type Model = String

data Computer = Computer Make Model deriving stock (Data, Show)
