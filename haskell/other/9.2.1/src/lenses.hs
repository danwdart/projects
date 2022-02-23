{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE UnicodeSyntax   #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

-- import Control.Monad
import           Control.Lens

a ∷ (Int, Int, Int)
a = (1, 2, 3)

data MyStruct = MyStruct {
    _namest    :: String,
    _age     :: Int,
    _friends :: [MyStruct]
} deriving (Show)

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


data Title = Citizen | Professor | Doctor deriving (Show)

data Date = Date {
    _year :: Int,
    _month :: Int,
    _day :: Int
} deriving (Show)

makeLenses ''Date

data Name = Name {
    _title :: Title,
    _givenName :: String,
    _officialName :: String
} deriving (Show)

makeLenses ''Name

data Event = Event {
    _summary :: String,
    _description :: String
} deriving (Show)

makeLenses ''Event

data Attributes = Attributes {
    _dob :: Date,
    _events :: [(Date, Event)]
} deriving (Show)

makeLenses ''Attributes

data Person = Person {
    _name :: Name,
    _attributes :: Attributes
} deriving (Show)

makeLenses ''Person

defaultPerson :: Person
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

newman :: Person
newman = defaultPerson
    & name . givenName .~ "Bobby"
    & name . officialName .~ "Bobby Jimbo III" -- TODO shortcut

main ∷ IO ()
main = do
    putStrLn $ newman ^. name . officialName
{-}
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
    -}
    {-}
    print a
    print $ a^._2
    print $ set _2 (42 :: Int) a
    print . (_2 .~ (42 :: Int)) $ a
    print $ a^._2
    print $ "Bob"^.to length
    print $ view _2 ((1, 2) :: (Int, Int))
    print $ (((1,0),(2,"Two"),(3,0)) :: ((Int, Int), (Int, String), (Int, Int)) )^._2._2.to length
    print $ (bob^.namest) <> (show (bob^.age) <> (bob^.friends.ix 0.namest))
    -}