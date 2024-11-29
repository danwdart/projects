module Main (main) where

import Credential
import Data.Foldable
import Person

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
main = traverse_ putStrLn [
    printCreds myCreds,
    "My name is " <> firstName me,
    describePerson me,
    describePerson someone]
