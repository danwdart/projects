{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE DuplicateRecordFields #-}
-- {-# LANGUAGE NoFieldSelectors #-} -- !!!
{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wwarn -Wno-unsafe #-}

module Main (main) where

import Data.Coerce
import Data.List
import Data.Map     (Map)
import Data.Map     qualified as Map
import Data.Time
-- import Data.Time.Calendar
-- import Data.Time.Format.ISO8601
import Control.Lens
import GHC.Records
import Text.Printf

data Title = Citizen | Professor | Doctor | Alien | Earthling deriving stock (Eq, Show, Read)

data Name = Name {
    title :: Title,
    name :: String
} deriving stock (Eq, Show)

data RelationType = SwornEnemy | Enemy | Unknown | Acquaintance | Friend | Lover
    deriving stock (Eq, Show)

data Relation = Relation {
    person :: Person,
    type' :: RelationType
}
    deriving stock (Eq, Show)

data Person = Person {
    name :: Name,
    coffees :: Int,
    relations :: [Relation]
}
    deriving stock (Eq, Show)

me :: Person
me = Person {
    name = Name {
        title = Citizen,
        name = "Void Ember"
    },
    coffees = 199,
    relations = [
        Relation {
            person = Person {
                name = Name {
                    title = Earthling,
                    name = "Bob"
                },
                coffees = 10,
                relations = [
                    Relation {
                        person = me,
                        type' = Friend
                    }
                ]
            },
            type' = Friend
        }
    ]
}

-- Evil stuff
newtype EvilString = EvilString {
    getString :: String
}

-- TODO labels so we can also do ^. #k?

-- Most of this doesn't need to be orphan instances...

instance HasField "splitBySpaces" EvilString [EvilString] where
    getField = fmap EvilString . words . getString

instance HasField "commaSeparated" [EvilString] EvilString where
    getField = EvilString . intercalate ", " . fmap getString

-- orphan
instance HasField "toEvil" String EvilString where
    getField = EvilString

instance HasField "fromEvil" EvilString String where
    getField = getString

-- we can do even more evil things like this...
instance HasField "putStrLn" String (IO ()) where
    getField = putStrLn

-- but we can't do this
-- instance (Show a) => HasField "print" a (IO ()) where
--     getField = print

-- Mwahahahaha!
instance HasField "doubled" Int Int where
    getField = (* 2)


data Blob = Blob {
    field1 :: String,
    field2 :: Int
} deriving stock (Eq, Show)

instance HasField "setField1" Blob (String -> Blob) where
    getField b s = b { field1 = s }

main :: IO ()
main = do
    "hi hi hi".toEvil.splitBySpaces.commaSeparated.fromEvil.putStrLn
    let b = Blob { field1 = "Hi", field2 = 22 }
    -- let c = b.setField1 "Hi 2"
    -- let c = b { field1 = "Hi 2" }
    (b.setField1 "Hi 2").field1.putStrLn


-- 
-- -- TODO prettyprint with contravariant
-- nameTitleGiven ∷ Name → String
-- nameTitleGiven p = printf "%s %s" (show (_nameTitle p)) (_nameChosenName p)
-- 
-- toTitleGiven ∷ Getter Name String
-- toTitleGiven = to nameTitleGiven
-- 
-- makeClassy ''Name
-- 
-- data Event = Event {
--     _eventDate        :: UTCTime,
--     _eventSummary     :: String,
--     _eventDescription :: String
-- } deriving stock (Eq, Show)
-- 
-- makeClassy ''Event
-- 
-- newtype Diary = Diary [Event] deriving newtype (Eq, Show)
-- 
-- makeWrapped ''Diary
-- 
-- data RelationType = Friend | Family | Acquaintance deriving stock (Eq, Show, Read)
-- 
-- data Person = Person {
--     _personName      :: Name,
--     _personDOB       :: Day,
--     _personRelations :: Relations,
--     _personDiary     :: Diary
-- } deriving stock (Eq, Show)
-- 
-- data Relation = Relation {
--     _relationPerson :: Person,
--     _relationType   :: RelationType
-- } deriving stock (Eq, Show)
-- 
-- newtype Relations = Relations [Relation] deriving newtype (Eq, Show)
-- 
-- makeWrapped ''Relations
-- makeClassy ''Person
-- makeClassy ''Relation
-- 
-- getYearsSince ∷ UTCTime → IO Int
-- getYearsSince t = do
--     now <- getCurrentTime
--     let diffGreg = diffUTCTime now t
--     let years = floor $ diffGreg / 365.2421 / 86400
--     pure years
-- 
-- getAge ∷ Day → IO Int
-- getAge t = do
--     let inUTC = UTCTime t 0
--     getYearsSince inUTC
-- 
-- year ∷ Getter UTCTime Integer
-- year = to utctDay . to toGregorian . _1
-- 
-- formattedDay ∷ Getter Day String
-- formattedDay = to showGregorian
-- 
-- commaSeparated ∷ Getter [String] String
-- commaSeparated = to (intercalate ", ")
-- 
-- appended ∷ Semigroup a ⇒ a → Getter a a
-- appended s = to (<> s)
-- 
-- written ∷ Getter String (IO ())
-- written = to putStrLn
-- 
-- printed ∷ Show a ⇒ Getter a (IO ())
-- printed = to print
-- 
-- -- idk
-- describeGirthily ∷ Getter Person String
-- describeGirthily = to $ \person' -> unwords [
--         person' ^. personName . nameTitle . to show,
--         person' ^. personName . nameChosenName . appended ",",
--         "also known as",
--         person' ^. personName . nameOfficialName <> ",",
--         "born on",
--         person' ^. personDOB . formattedDay,
--         "was set upon in",
--         person' ^. personDiary . _Wrapped . partsOf (traverse . eventDate . year . to show) . commaSeparated,
--         "and decided respectively:",
--         person' ^. personDiary . _Wrapped . partsOf (traverse . event . eventSummary) . commaSeparated <> ".",
--         "These were the dates:",
--         person' ^. personDiary . _Wrapped . partsOf (traverse . eventDate . to utctDay . to showGregorian) . commaSeparated
--     ]
-- 
-- defaultPerson ∷ Person
-- defaultPerson = Person (
--         Name Doctor "Pickle" "James Robert Pickle"
--     ) (
--         fromGregorian 1945 3 21
--     ) (Relations []) (Diary [
--             Event (UTCTime (fromGregorian 1970 1 1) 0) "Created universe" "Created the universe.",
--             Event (UTCTime (fromGregorian 1980 1 1) 0)"Got tired" "Had enough of this nonsense."
--         ]
--     )
-- 
-- newman ∷ Person
-- newman = defaultPerson
--     & personName %~ (
--         (nameChosenName .~ "Bobby") .
--         (nameOfficialName .~ "Bobby Jimbo III")
--     )
--     & personDiary . _Wrapped %~ (
--         -- Add a year and set day to 24 for each event?
--         -- (traverse . eventDate %~ (
--         --     (year %~ succ) .
--         --     (day .~ 24)
--         -- )) .
--         (ix 0 . event . eventDescription .~ "Actually...")
--         .
--         (<> [Event (UTCTime (fromGregorian 1990 1 1) 0) "Did a thing" "More about the thing."])
--     )
--     & personDOB .~ fromGregorian 1980 1 8
--     & personDiary . _Wrapped <>~ [Event (UTCTime (fromGregorian 1991 2 2) 0) "Did another thing" "More about the other thing."]
-- 
-- main ∷ IO ()
-- main = do
--     let a = (1, 2) :: (Int, Int)
--     ((Map.empty :: Map Int String) & at 2 ?~ "hello" & at 3 ?~ "world") ^. printed
--     a ^. printed
--     a ^. _2 . printed
--     set _2 (42 :: Int) a ^. printed
--     (a & _2 .~ (42 :: Int)) ^. printed
--     "Bob" ^. to length . printed
--     view _2 a ^. printed
--     (((1,0),(2,"Two"),(3,0)) :: ((Int, Int), (Int, String), (Int, Int)) ) ^. _2 . _2 . to length . printed
--     newman ^. (describeGirthily . written)

-- And evil versions too!