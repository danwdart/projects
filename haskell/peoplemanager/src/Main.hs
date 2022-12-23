{-# LANGUAGE DeriveAnyClass, DerivingVia, UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Main where

import           Control.Monad
import Control.Monad.Random
import           Data.Functor
-- import qualified Data.Set as S
import           Data.Set      (Set)
import qualified Data.Set as S
import           Data.Text     (Text)
import qualified Data.Text     as T
import           Data.Time
-- import Data.Time.Calendar
import           Data.UUID
import           Data.UUID.V4
import           Data.Word
import           Faker
import qualified Faker.Address as FA
import qualified Faker.Name    as FN
import GHC.Generics
-- import           System.Random

generateND ∷ Fake a → IO a
generateND = generateWithSettings $ setNonDeterministic defaultFakerSettings

today ∷ IO Day
today = utctDay <$> getCurrentTime

diffYears ∷ Day → Day → Integer
diffYears to' from' = diffDays from' to' `div` 365

yearsAgo ∷ Day → IO Integer
yearsAgo from' = today Data.Functor.<&> diffYears from'

data ADHDType = PrimarilyHyperactive | PrimarilyInattentive
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data AnxietyType = Generalised | SituationalAnxiety
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data AutismLevel = HighFunctioning | MidFunctioning | LowFunctioning
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data DepressionType = Clinical | SituationalDepression
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data Condition = ADHD ADHDType | Anxiety AnxietyType | Autism AutismLevel | Depression DepressionType
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data AcuteIllness = CommonCold | Influenza | NondescriptLurgy
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data ChronicIllness = Eczema | HidradenitisSupprativa
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data Illness = Acute AcuteIllness | Chronic ChronicIllness
    deriving stock (Eq, Show, Ord) -- just so we can shove it in a Set

data Attribs = Attribs {
    conditions :: Set Condition,
    happiness :: Word8,
    health :: Word8,
    illnesses :: Set Illness,
    intelligence :: Word8,
    magic :: Word8,
    morality :: Word8,
    stamina :: Word8,
    strength :: Word8
} deriving stock (Eq, Show, Ord) -- there really is no Ord

instance {-# OVERLAPPABLE #-} (Bounded a, Enum a) => Random a where
  random = randomR (minBound, maxBound)

  randomR (f, t) gen =
    let (rndInt, nxtGen) = randomR (fromEnum f, fromEnum t) gen
     in (toEnum rndInt, nxtGen)

data Title = Mr | Ms | Miss | Mrs | Mx | Dr | Prof | Rev | Col
    deriving stock (Eq, Show, Ord, Generic, Enum, Bounded)

data Person = Person {
    uuid    :: UUID,
    title   :: Title,
    name    :: Text,
    dob     :: Day,
    city    :: Text,
    country :: Text,
    attribs :: Attribs
} deriving stock (Eq, Ord) -- Ord is a bit funky, there's really no explicit ordering here

instance Show Person where
    show Person {title, name, dob, city, country} = show title <> ". " <> T.unpack name <> (", born " <> (show dob <> (", from " <> (T.unpack city <> (", " <> T.unpack country)))))

makePerson ∷ IO Person
makePerson = do
    -- TODO combinator for monads to records - seq? sig: m a -> m b -> (a -> b -> m c) -> m c etc.
    -- maybe it's https://hackage.haskell.org/package/monad-state-0.2.0.3/docs/Control-Monad-Record.html ?
    -- TODO unzip?
    [name, city, country] <- mapM generateND [FN.name, FA.city, FA.country]
    uuid <- nextRandom
    title <- randomIO :: IO Title
    dob <- ModifiedJulianDay <$> randomRIO (20000, 50000)
    pure Person {
        uuid,
        title,
        name,
        dob,
        city,
        country,
        attribs = Attribs { -- todo randomness
            conditions = S.empty,
            happiness = 255,
            health = 255,
            illnesses = S.empty,
            intelligence = 255,
            magic = 255,
            morality = 255,
            stamina = 255,
            strength = 255
        }
    }

makePeople ∷ Int → IO (Set Person)
makePeople number = S.fromList <$> replicateM number makePerson

data RelationshipType = Married | Couple | Family | Friend | Coworker | Enemy | Indifferent deriving stock (Eq, Ord, Show)

data Relationship = Relationship RelationshipType Person Person

-- TODO stop circulars? Maybe not?

instance Show Relationship where
    show (Relationship t (Person _ _ name1 _ _ _ _) (Person _ _ name2 _ _ _ _)) = show t <> (": " <> (T.unpack name1 <> (" & " <> T.unpack name2)))

-- Bidirectional equality
instance Eq Relationship where
    Relationship t1 p1 q1 == Relationship t2 p2 q2 = t1 == t2 && ((p1 == p2 && q1 == q2) || (p1 == q2 && p2 == q1))

makePairs ∷ Set Person → Set (Person, Person)
makePairs = undefined

pairToRelationship ∷ RelationshipType → (Person, Person) → Relationship
pairToRelationship t (p1, p2) = Relationship t p1 p2

makeRelationships ∷ Set Person → IO (Set Relationship)
makeRelationships = undefined

main ∷ IO ()
main =  do
    putStrLn "Generating people..." -- lol I'm god
    people <- makePeople 20
    mapM_ print people
    putStrLn "Mapping relationships..."
