{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Network.DigitalOcean.CloudFunctions.Handler where

import           Control.Monad.IO.Class
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL

handle :: forall from to m. (FromJSON from, ToJSON to, MonadIO m) => (from -> m to) -> m ()
handle f = do
    input <- liftIO BSL.getContents

    let mInputDecoded :: Maybe from
        mInputDecoded = decode input
    
    case mInputDecoded of
        Nothing -> liftIO . BSL.putStrLn . encode $ Array []
        Just inputDecoded -> do
            output <- f inputDecoded :: m to

            liftIO . BSL.putStrLn . encode $ output
