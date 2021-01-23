{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import Data.Char
import GHC.Read
import Text.ParserCombinators.ReadP
import Text.ParserCombinators.ReadPrec (lift)
import Debug.Trace

data Person = Person {
    name :: String,
    age :: Int
} deriving (Show)

instance Read Person where
    readsPrec _ = readP_to_S $ do        
        name <- manyTill get (char ',')
        skipSpaces
        age <- read <$> munch1 isDigit
        pure $ Person name age

data Person2 = Person2 {
    name2 :: String,
    age2 :: Int
} deriving (Show)

instance Read Person2 where
    readPrec = lift $ do        
        name <- manyTill get (char ',')
        skipSpaces
        age <- read <$> munch1 isDigit
        pure $ Person2 name age

desc :: String
desc = "Dan, 29"

me :: Person
me = read desc

me2 :: Person2
me2 = read desc

main ∷ IO ()
main = do
    print me
    print me2