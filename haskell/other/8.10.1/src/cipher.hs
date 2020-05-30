{-# LANGUAGE DeriveFunctor #-}

import Control.Applicative
import Data.Char
import Data.List
import Data.Maybe

consonants, vowels :: String
consonants = "bcdfghjklmnpqrstvwxyz"
vowels = "aeiou"

data Letter x = Vowel x | Consonant x | Other x deriving (Eq, Show, Functor)

index :: Char -> Maybe (Letter Int)
index c = fmap Consonant (c `elemIndex` consonants) <|>
          fmap Vowel (c `elemIndex` vowels) <|>
          Other <$> Just (ord c)

cipherChar :: Int -> Char -> Maybe Char
cipherChar n c = toChar n <$> index c

modIndex :: Int -> [a] -> a
modIndex i xs = xs !! (i `mod` length xs)

toChar :: Int -> Letter Int -> Char
toChar i (Consonant n) = modIndex (n + i) consonants
toChar i (Vowel n) = modIndex (n + i) vowels
toChar _ (Other n) = chr n

cipher :: Int -> String -> String
cipher k = mapMaybe (cipherChar k . toLower)

main :: IO ()
main = putStrLn $ cipher 2 "Hi world! My name is Bob!"