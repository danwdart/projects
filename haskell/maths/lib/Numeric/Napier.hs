module Numeric.Napier where

import Data.Digits   (digitsRev)
import Data.Function ((&))
import Data.Functor  ((<&>))
import Data.List     (elemIndex)
import Data.Maybe    (catMaybes, mapMaybe)

napierSymbols ∷ String
napierSymbols = ['a'..'z'] <> ['A'..'Z']

newtype Locar = Locar { getNumber :: Int }

toMaybe ∷ a → Bool → Maybe a
toMaybe l b =
    if b
    then Just l
    else Nothing

-- todo filter by list instead of that monstrosity

instance Show Locar where
    show (Locar n) = digitsRev 2 n <&> (1 ==) & zipWith toMaybe napierSymbols & catMaybes & reverse

fromString ∷ String → Locar
fromString a = mapMaybe (`elemIndex` napierSymbols) (a & filter (`elem` napierSymbols)) <&> (2 ^) & sum & Locar

symToInt ∷ String → Int
symToInt = getNumber . fromString
