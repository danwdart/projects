{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module MyHandler where

import Control.Monad.IO.Class
import Data.Aeson
import GHC.Generics

data MyData = MyData {
    myString :: String,
    myInt :: Int
}
    deriving stock (Eq, Show, Generic)
    deriving anyclass (FromJSON, ToJSON)

myHandler :: MonadIO m => MyData -> m MyData
myHandler = pure