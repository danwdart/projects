{-# LANGUAGE Safe #-}

module StringToInteger where

import Data.Char
import Numeric

stringToInteger ∷ String → Integer
stringToInteger string = fst $ head (readHex $ concatMap ((`showHex` "") . ord) (filter notSpaces string)) where
    notSpaces = (/= ' ')
