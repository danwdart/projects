{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-x-partial #-}

module StringToInteger where

import Data.Char
import Numeric

stringToInteger ∷ String → Integer
stringToInteger string = fst $ (case readHex $ concatMap ((`showHex` "") . ord) (filter notSpaces string) of
   x : _ -> x
   []    -> error _) where
    notSpaces = (/= ' ')
