{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}

module Cipher where

import           Control.Applicative
import           Data.Char
import           Data.List
import           Data.Maybe

consonants, vowels, consCaps, vowelCaps ∷ String
consonants = "bcdfghjklmnpqrstvwxz"
vowels = "aeiouy"
consCaps = "BCDFGHJKLMNPQRSTVWXZ"
vowelCaps = "AEIOUY"

data Letter x = Vowel x | Consonant x | VowelCap x | ConsCap x | Other x deriving (Eq, Show, Functor)

index ∷ Char → Maybe (Letter Int)
index c = Consonant <$> (c `elemIndex` consonants) <|>
          Vowel <$> (c `elemIndex` vowels) <|>
          VowelCap <$> (c `elemIndex` vowelCaps) <|>
          ConsCap <$> (c `elemIndex` consCaps) <|>
          Other <$> Just (ord c)

cipherChar ∷ Int → Char → Maybe Char
cipherChar n c = toChar n <$> index c

modIndex ∷ Int → [a] → a
modIndex i xs = xs !! (i `mod` length xs)

toChar ∷ Int → Letter Int → Char
toChar i (Consonant n) = modIndex (n + i) consonants
toChar i (Vowel n)     = modIndex (n + i) vowels
toChar i (VowelCap n)  = modIndex (n + i) vowelCaps
toChar i (ConsCap n)   = modIndex (n + i) consCaps
toChar _ (Other n)     = chr n

cipher ∷ Int → String → String
cipher = mapMaybe . cipherChar

cyclingCipher ∷ String → String
cyclingCipher str = do
    ch <- zip [1..] str
    let (Just ch2) = uncurry cipherChar ch
    pure ch2
