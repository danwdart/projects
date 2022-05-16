module Main where

import Data.Function
import MyLens
import MyLens.Date
-- import MyLens.Tuple
-- import MyLens.Triple
import MyLens.Title
import MyLens.Name
import MyLens.Event
import MyLens.Attribute
import MyLens.Person

defaultPerson ∷ Person
defaultPerson = Person (
        Name Doctor "Pickle" "James Robert Pickle"
    ) (
        Attributes (Date 1945 3 21) [
            (
                Date 1970 1 1,
                Event "Created universe" "Created the universe."
            ),
            (
                Date 1980 1 1,
                Event "Got tired" "Had enough of this nonsense."
            )
            ]
    )

newman ∷ Person
newman = defaultPerson
    & name . givenName .~ "Bobby"
    & name . officialName .~ "Bobby Jimbo III" -- TODO shortcut

main ∷ IO ()
main = do
    putStrLn $
        show (name . title ^. newman)
        <>
        " "
        <>
        (name . givenName ^. newman)
        <>
        ", also known as "
        <>
        (name . officialName ^. newman)
        <>
        " was set upon."
        -- <>
        -- show (attributes . events ^. newman)
    pure ()
    -- print $ set _1 "c" ("a", 1)
    -- print $ set _2 "b" (9, 9)
    -- print $ view _1 ("a", "b")
    -- print $ view _2 ("a", "b")
    -- print $ over _2 succ (1, 1)
    -- print $ over _1 succ (1, 1)
    -- print . set lensTripleA "llll" $ Triple 1 2 3
    -- print . set lensTripleB "bbbb" $ Triple 'a' 'b' 'c'
    -- print . set lensTripleC "bbbb" $ Triple True False True
