{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedLists #-}

module MyHandler where

import Control.Monad.IO.Class
import Data.Aeson
import GHC.Generics
import Network.DigitalOcean.CloudFunctions.Request as Request
import Network.DigitalOcean.CloudFunctions.Response as Response

data MyData = MyData {
    myString :: String,
    myInt :: Int
}
    deriving stock Generic
    deriving anyclass (FromJSON, ToJSON)

myHandler :: MonadIO m => Request MyData -> m (Response MyData)
myHandler Request { path = _path', Request.headers = _headers', method = _method', http = _http', args = args', ctx = _ctx' } =
    pure $ Response {
        body = args',
        statusCode = 200,
        Response.headers = [
            ("Content-Type", "application/json")
            ]
    }