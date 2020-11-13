module Lib.Person (
    Person (..),
    describePerson
) where

import Data.List

data Person = Person {
    firstName :: String,
    lastName :: String,
    birthYear :: Int,
    hatsOwned :: [String]
} deriving (Show)

-- Private
wordlist :: String -> [String] -> String
wordlist whats [] = "no " ++ whats ++ "!"
wordlist whats xs = "a massive array of " ++ whats ++ ", including: " ++
    intercalate ", " inits ++ " and " ++ lasts ++ "!"
    where inits = init xs
          lasts = last xs

describePerson :: Person -> String
describePerson Person {
    firstName = firstName,
    lastName = lastName,
    birthYear = birthYear,
    hatsOwned = hatsOwned
} = firstName ++ " " ++ lastName ++
    " was born in " ++ show birthYear ++
    " and has " ++
    wordlist "hats" hatsOwned