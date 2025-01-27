{-# LANGUAGE Safe #-}

module Person (
    Person (..),
    describePerson
) where

import Data.List

data Person = Person {
    firstName :: String,
    lastName  :: String,
    birthYear :: Int,
    hatsOwned :: [String]
} deriving stock (Show)

-- Private
wordlist ∷ String → [String] → String
wordlist whats [] = "no " <> (whats <> "!")
wordlist whats xs = "a massive array of " <> (whats <> (", including: " <> (
    intercalate ", " initss <> (" and " <> (lasts <> "!")))))
    where initss = case reverse xs of
            _ : xs -> reverse xs
            []     -> error _
          lasts = case reverse xs of
            x : _ -> x
            []    -> error _

describePerson ∷ Person → String
describePerson Person {
    firstName = sFirstName,
    lastName = sLastName,
    birthYear = iBirthYear,
    hatsOwned = lHatsOwned
} = sFirstName <> (" " <> (sLastName <> (
    " was born in " <> (show iBirthYear <> (
    " and has " <>
    wordlist "hats" lHatsOwned)))))
