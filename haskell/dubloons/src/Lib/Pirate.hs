{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall -Werror -Wno-type-defaults -Wno-unused-imports #-}

module Lib.Pirate where

import Control.Monad.Except
import Control.Monad.IO.Class (liftIO)
import Control.Retry
import Data.Aeson
import qualified Data.ByteString.Char8 as B
import Data.Function
import Data.Functor
import qualified Data.Text as T
import Data.Text (Text)
import Lib.XPath
import Network.HTTP.Client hiding (responseBody)
import Network.HTTP.Req

-- Don't error on 404. We just wanna check it.
{-torConfig :: HttpConfig
torConfig = defaultHttpConfig {
    httpConfigProxy = Just (Proxy "localhost" 8118)
}-}

getSearch :: Text -> Text -> Req BsResponse
getSearch hostname term = req GET (https hostname /: "search" /: term) NoReqBody bsResponse
    $ header "User-Agent" "Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"

queryPirate :: Text -> Text -> IO [(String, String)]
queryPirate hostname t = do
    r <- runReq defaultHttpConfig $ getSearch hostname t
    getMatches . B.unpack $ responseBody r