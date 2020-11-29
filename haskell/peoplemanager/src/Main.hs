{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE UnicodeSyntax  #-}
module Main where

import           Control.Monad
-- import qualified Data.Set as S
import           Data.Set      (Set)
import           Data.Text     (Text)
import qualified Data.Text     as T
import           Data.Time
-- import Data.Time.Calendar
import           Data.UUID
import           Data.UUID.V4
import           Faker
import qualified Faker.Address as FA
import qualified Faker.Name    as FN
import           System.Random

fakerSettings ∷ FakerSettings
fakerSettings = setNonDeterministic defaultFakerSettings

generateND ∷ Fake a → IO a
generateND = generateWithSettings fakerSettings

today ∷ IO Day
today = utctDay <$> getCurrentTime

diffYears ∷ Day → Day → Integer
diffYears to from = diffDays from to `div` 365

yearsAgo ∷ Day → IO Integer
yearsAgo from = today >>= (return . diffYears from)

data Person = Person {
    uuid    :: Text,
    name    :: Text,
    dob     :: Day,
    city    :: Text,
    country :: Text
} deriving (Eq)

instance Show Person where
    show (Person _ name dob city country) = T.unpack name <> (", born " <> (show dob <> (", from " <> (T.unpack city ++ ", " ++ T.unpack country))))

makePerson ∷ IO Person
makePerson = do
    -- TODO combinator for monads to records - seq? sig: m a -> m b -> (a -> b -> m c) -> m c etc.
    -- maybe it's https://hackage.haskell.org/package/monad-state-0.2.0.3/docs/Control-Monad-Record.html ?
    -- TODO unzip?
    [name, city, country] <- sequence $ generateND <$> [FN.name, FA.city, FA.country]
    uuid <- toText <$> nextRandom
    dob <- ModifiedJulianDay <$> randomRIO (20000, 50000)
    return Person {
        uuid,
        name,
        dob,
        city,
        country
    }

makePeople ∷ Int → IO [Person]
makePeople number = replicateM number makePerson

data RelationshipType = Married | Couple | Family | Friend | Coworker | Enemy | Indifferent deriving (Eq, Ord, Show)

data Relationship = Relationship RelationshipType Person Person

-- TODO stop circulars? Maybe not?

instance Show Relationship where
    show (Relationship t (Person _ name1 _ _ _) (Person _ name2 _ _ _)) = show t <> (": " <> (T.unpack name1 <> (" & " <> T.unpack name2)))

-- Bidirectional equality
instance Eq Relationship where
    Relationship t1 p1 q1 == Relationship t2 p2 q2 = t1 == t2 && ((p1 == p2 && q1 == q2) || (p1 == q2 && p2 == q1))

makePairs ∷ [Person] → IO (Set (Person, Person))
makePairs = undefined

pairToRelationship ∷ RelationshipType → (Person, Person) → Relationship
pairToRelationship t (p1, p2) = Relationship t p1 p2

makeRelationships ∷ [Person] → IO (Set Relationship)
makeRelationships = undefined

main ∷ IO ()
main =  do
    putStrLn "Generating people..." -- lol I'm god
    people <- makePeople 20
    mapM_ print people
    putStrLn "Mapping relationships..."
