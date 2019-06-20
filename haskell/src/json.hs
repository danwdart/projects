{-# LANGUAGE DeriveGeneric #-}

import Data.ByteString.Lazy.Internal
import Data.Aeson
import GHC.Generics

data Person = Person {
      name :: String
    , age  :: Int
    } deriving (Generic, Show)

instance ToJSON Person where
    toEncoding = genericToEncoding defaultOptions
instance FromJSON Person

main = do
    putStrLn "TODO"
    -- putStrLn $ encode (Person {name = "Joe", age = 12})
    -- print (decode "{\"name\":\"Joe\",\"age\":12}" :: Maybe Person)
         