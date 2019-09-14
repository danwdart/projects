{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.IO.Class
import Data.Aeson
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BSL
import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp

app :: Application
app req res = do
    let host = remoteHost req
    let method = requestMethod req
    let path = pathInfo req
    let headers = requestHeaders req
    liftIO . print $ req
    body <- getRequestBodyChunk req
    let mAccept = lookup "Accept" headers
    let mCT = lookup "Content-Type" headers
    let resp = maybe "Hello World!" id $ do
        accept <- mAccept
        ct <- mCT
        return $ accept `BS.append` ct
    

    res $ responseLBS status200 [] $ BSL.fromChunks [resp]

main :: IO ()
main = run 3000 app