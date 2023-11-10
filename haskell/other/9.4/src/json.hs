{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE Trustworthy       #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

-- import Control.Exception
-- import Data.ByteString qualified as BS
import Data.Aeson
import Data.Aeson.QQ
import GHC.Generics

-- Automatic
data Person = Person {
      name :: String
    , age  :: Int
}
    deriving stock (Generic, Show)
    deriving anyclass (FromJSON, ToJSON)

myPerson ∷ Person
myPerson = Person {
    name = "Joe",
    age = 42
}

-- Manual
myVal ∷ Value
myVal = Object ("bob" .= String "Ted")

myQQ ∷ Value
myQQ = [aesonQQ| { "a": "b", "c": #{show (age myPerson)} } |]

main ∷ IO ()
main = do
    print $ encode myPerson
    print (decode "{\"name\":\"Bob\",\"age\":28}" :: Maybe Person)
    print (decode "{\"name\":\"Bobby Jimbo\",\"age\":28,\"location\":\"Elsewhere\"}" :: Maybe Person)
    print (decode "{\"name\":\"Bobby Jimbo\"}" :: Maybe Person)
    print $ encode myVal
    print $ encode myQQ
    print (decode "{\"Arbitrary\":{\"Object\":286}}" :: Maybe Value)
    print (decode "{\"Arbitrary\":{\"Object\":286}}" :: Maybe ())
