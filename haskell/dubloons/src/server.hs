{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.IO.Class
import Data.ByteString.Lazy.Char8 (ByteString)
import qualified Data.ByteString.Lazy.Char8 as BSL
import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp

app :: Application
app req res = do
    let host = remoteHost req
    let method = requestMethod req
    let path = pathInfo req
    res $ responseLBS status200 [] $ "Hi, "
        `BSL.append` (BSL.pack (show host))
        `BSL.append` " - "
        `BSL.append` BSL.fromChunks [method]
        `BSL.append` " - "
        `BSL.append` (BSL.pack (show path))

main :: IO ()
main = run 3000 app