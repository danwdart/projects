{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Network.DigitalOcean.CloudFunctions.Request where

import Data.Aeson
-- import Data.Map qualified as M
import Data.Map (Map)
import GHC.Generics

data Request a = Request {
    path :: String,
    headers :: Map String String,
    method :: String, -- @TODO enum
    http :: Value,
    args :: a,
    ctx :: Value
}
    deriving stock Generic
    deriving anyclass FromJSON