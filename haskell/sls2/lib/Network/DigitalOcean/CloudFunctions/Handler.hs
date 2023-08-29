{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Network.DigitalOcean.CloudFunctions.Handler where

import           Control.Monad.IO.Class
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL
import qualified Data.Text as T
import Network.DigitalOcean.CloudFunctions.Response

handle :: forall from to m. (FromJSON from, ToJSON to, MonadIO m) => (from -> m to) -> m ()
handle f = do
    input <- liftIO BSL.getContents

    let mInputDecoded :: Either String from
        mInputDecoded = eitherDecode input
    
    case mInputDecoded of
        Left error' -> liftIO . BSL.putStrLn . encode $ Response {
            body = Object [
                "message" .= String "Decode error caught",
                "error" .= String (T.pack error')
            ],
            statusCode = 400,
            headers = [
                ("Content-Type", "application/json")
                ]
        }
        Right inputDecoded -> do
            output <- f inputDecoded :: m to

            liftIO . BSL.putStrLn . encode $ output
