{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

-- import Control.Exception
-- import qualified Data.ByteString as BS
import           Data.Aeson   ((.=))
import qualified Data.Aeson   as A
import           GHC.Generics

-- Automatic
data Person = Person {
      name :: String
    , age  :: Int
    } deriving (A.FromJSON ,A.ToJSON, Generic, Show)

myPerson :: Person
myPerson = Person {
    name = "Joe",
    age = 42
}

-- Manual
myVal :: A.Value
myVal = A.Object ("bob" .= A.String "Ted")

main :: IO ()
main = do
    print $ A.encode myPerson
    print (A.decode "{\"name\":\"Bob\",\"age\":28}" :: Maybe Person)
    print (A.decode "{\"name\":\"Bobby Jimbo\",\"age\":28,\"location\":\"Elsewhere\"}" :: Maybe Person)
    print (A.decode "{\"name\":\"Bobby Jimbo\"}" :: Maybe Person)
    print $ A.encode myVal
    print (A.decode "{\"Arbitrary\":{\"Object\":286}}" :: Maybe A.Value)
    print (A.decode "{\"Arbitrary\":{\"Object\":286}}" :: Maybe ())
