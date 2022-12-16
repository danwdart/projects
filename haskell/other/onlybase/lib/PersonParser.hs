module PersonParser where

import           Data.Char
import           GHC.Read
import           Text.ParserCombinators.ReadP
import           Text.ParserCombinators.ReadPrec (lift)

data Person = Person {
    name :: String,
    age  :: Int
} deriving stock (Show)

instance Read Person where
    readsPrec _ = readP_to_S $ personParser Person

data Person2 = Person2 {
    name2 :: String,
    age2  :: Int
} deriving stock (Show)

instance Read Person2 where
    readPrec = lift $ personParser Person2

personParser ∷ (String → Int → a) → ReadP a
personParser c = do
    name' <- manyTill get (char ',')
    skipSpaces
    age' <- read <$> munch1 isDigit
    pure $ c name' age'
