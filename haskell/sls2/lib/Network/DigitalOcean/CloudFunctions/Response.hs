{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Network.DigitalOcean.CloudFunctions.Response where

import Data.Aeson
-- import Data.Map qualified as M
import Data.Map (Map)
import GHC.Generics

data Response a = Response {
    body :: a, -- @TODO a bytestring?
    statusCode :: Int, -- @TODO a word type?
    headers :: Map String String
}
    deriving stock Generic
    deriving anyclass ToJSON