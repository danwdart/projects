<<<<<<< Updated upstream:haskell/other/8.10.2/src/data.hs
{-# LANGUAGE UnicodeSyntax #-}
module Main where

import           Lib.Credential
import           Lib.Person

myCreds ∷ Creds
myCreds = Creds "Username" "Password"

me ∷ Person
me = Person {
    firstName = "Dan",
    lastName = "Dart",
    birthYear = 1991,
    hatsOwned = ["Lightbulb Bowler", "Topper", "Spanish", "Pope"]
}

someone ∷ Person
someone = Person {
    firstName = "Bob",
    lastName = "Frog",
    birthYear = 1752,
    hatsOwned = []
}

main ∷ IO ()
main = mapM_ putStrLn [
    printCreds myCreds,
    "My name is " <> firstName me,
    describePerson me,
    describePerson someone]
=======
module Main where

import Lib.Credential
import Lib.Person

myCreds :: Creds
myCreds = Creds "Username" "Password"

me = Person {
    firstName = "Dan",
    lastName = "Dart",
    birthYear = 1991,
    hatsOwned = ["Lightbulb Bowler", "Topper", "Spanish", "Pope"]
}

someone = Person {
    firstName = "Bob",
    lastName = "Frog",
    birthYear = 1752,
    hatsOwned = []
}

main :: IO ()
main = mapM_ putStrLn [
    printCreds myCreds,
    "My name is " ++ firstName me,
    describePerson me,
    describePerson someone]
>>>>>>> Stashed changes:haskell/data.hs
