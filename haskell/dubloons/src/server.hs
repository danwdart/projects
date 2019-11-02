{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.IO.Class
-- import Data.Aeson
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Lazy.Char8 as BSL
import Network.HTTP.Types
import Network.Wai
import Network.Wai.Handler.Warp

{-
encodeResponse :: (ToJSON a) => BSL.ByteString -> a -> BSL.ByteString
encodeResponse "application/json" = encode
encodeResponse _ = undefined

decodeRequest :: (FromJSON a) => BSL.ByteString -> BSL.ByteString -> Maybe a
decodeRequest "application/json" = decode
decodeRequest _ = undefined
-}

app :: Application
app req res = do
    -- let host = remoteHost req
    -- let method = requestMethod req
    -- let path = pathInfo req
    let headers = requestHeaders req
    liftIO . print $ req
    -- body <- getRequestBodyChunk req
    let mAccept = lookup "Accept" headers
    let mCT = lookup "Content-Type" headers
    let resp = fromMaybe "Hello World!" $ do
                                            accept <- mAccept
                                            ct <- mCT
                                            return $ accept `BS.append` ct
    res $ responseLBS status200 [] $ BSL.fromChunks [resp]

main :: IO ()
main = run 3000 app