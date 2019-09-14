{-# LANGUAGE NamedFieldPuns #-}

import Data.Text (Text)
import Data.Time
import Data.Time.Calendar
import Faker
import qualified Faker.Address as FA
import qualified Faker.Name as FN
import System.Random

fakerSettings :: FakerSettings
fakerSettings = setNonDeterministic defaultFakerSettings

generateND :: Fake a -> IO a
generateND = generateWithSettings fakerSettings

data Person = Person {
    name :: Text,
    dob :: Day,
    city :: Text,
    country :: Text
} deriving (Eq, Show)

makePerson :: IO Person
makePerson = do
    -- TODO combinator for monads to records - seq? sig: m a -> m b -> (a -> b -> m c) -> m c etc.
    -- maybe it's https://hackage.haskell.org/package/monad-state-0.2.0.3/docs/Control-Monad-Record.html ?
    name <- generateND FN.name
    city <- generateND FA.city
    country <- generateND FA.country
    day <- randomRIO (20000, 50000)
    let dob = ModifiedJulianDay day
    return Person {
        name,
        dob,
        city,
        country
    }

main :: IO ()
main = makePerson >>= print