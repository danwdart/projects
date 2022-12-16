{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-redundant-constraints -Wno-unused-top-binds #-}

import           Data.List
-- import Control.Monad
import           Control.Lens

a ∷ (Int, Int, Int)
a = (1, 2, 3)

data MyStruct = MyStruct {
    _namest  :: String,
    _age     :: Int,
    _friends :: [MyStruct]
} deriving stock (Show)

makeLenses ''MyStruct

bob ∷ MyStruct
bob = MyStruct {
    _namest = "Bob",
    _age = 27,
    _friends = [
        MyStruct {
            _namest = "Jim",
            _age = 27,
            _friends = []
        }
    ]
}


data Title = Citizen | Professor | Doctor deriving stock (Show)

data Date = Date {
    _year  :: Int,
    _month :: Int,
    _day   :: Int
} deriving stock (Show)

makeLenses ''Date

fullDate ∷ Getter Date String
fullDate = to (
    \d ->
        d ^. year . to show
        <>
        "-"
        <>
        d ^. month . to show
        <>
        "-"
        <>
        d ^. day . to show
    )

data Name = Name {
    _title        :: Title,
    _givenName    :: String,
    _officialName :: String
} deriving stock (Show)

makeLenses ''Name

data Event = Event {
    _summary     :: String,
    _description :: String
} deriving stock (Show)

makeLenses ''Event

data Attributes = Attributes {
    _dob    :: Date,
    _events :: [(Date, Event)]
} deriving stock (Show)

date ∷ Lens' (Date, Event) Date
date = _1

event ∷ Lens' (Date, Event) Event
event = _2

makeLenses ''Attributes

data Person = Person {
    _name       :: Name,
    _attributes :: Attributes
} deriving stock (Show)

makeLenses ''Person

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
    & name %~ (
        (givenName .~ "Bobby") .
        (officialName .~ "Bobby Jimbo III")
    )
    & attributes . events %~ (
        (traverse . date %~ (
            (year %~ succ) .
            (day .~ 24)
        )) .
        (ix 0 . event . description .~ "Actually...")
        .
        (<> [(Date 1990 1 1, Event "Did a thing" "More about the thing.")])
    )
    & attributes . dob .~ Date 1980 1 8
    & attributes . events <>~ [(Date 1991 2 2, Event "Did another thing" "More about the other thing.")]

main ∷ IO ()
main = do
    print a
    print $ a ^. _2
    print $ set _2 (42 :: Int) a
    print . (_2 .~ (42 :: Int)) $ a
    print $ a ^. _2
    print $ "Bob" ^. to length
    print $ view _2 ((1, 2) :: (Int, Int))
    print $ (((1,0),(2,"Two"),(3,0)) :: ((Int, Int), (Int, String), (Int, Int)) ) ^. _2 . _2 . to length
    print $ (bob ^. namest) <> (show (bob ^. age) <> (bob ^. friends.ix 0.namest))
    putStrLn $
        show (newman ^. name . title)
        <>
        " "
        <>
        (newman ^. name . givenName)
        <>
        ", also known as "
        <>
        (newman ^. name . officialName)
        <>
        ", born on "
        <>
        (newman ^. attributes . dob . fullDate)
        <>
        " was set upon in "
        <>
        newman ^. attributes . events . partsOf (traverse . date . year . to show) . to (intercalate ", ")
        <>
        " and decided respectively: "
        <>
        newman ^. attributes . events . partsOf (traverse . event . summary) . to (intercalate ", ")
        <>
        ". These were the dates: "
        <>
        newman ^. attributes . events . partsOf (traverse . date . fullDate) . to (intercalate ", ")
