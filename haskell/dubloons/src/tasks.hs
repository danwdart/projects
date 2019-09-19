{-# LANGUAGE OverloadedStrings #-}

-- import Control.Monad.Except
import Control.Monad.IO.Class (liftIO)
-- import Control.Retry
-- import Data.Aeson
-- import qualified Data.ByteString.Char8 as B
-- import Data.Function
-- import Data.Functor
import qualified Data.Text as T
-- import Lib.XPath
-- import Network.HTTP.Client hiding (responseBody)
import Network.HTTP.Req

-- Don't error on 404. We just wanna check it.
{-torConfig :: HttpConfig
torConfig = defaultHttpConfig {
    httpConfigProxy = Just (Proxy "localhost" 8118)
}-}

getSearch :: T.Text -> Req BsResponse
getSearch term = req GET (https "thepirate.live" /: "search" /: term) NoReqBody bsResponse
    $ header "User-Agent" "Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"

main :: IO ()
main = runReq defaultHttpConfig $ do
    r <- getSearch "debian"
    let bodyText = responseBody r
    liftIO . print $ bodyText
    --let results = bodyText <&> show <&> processXPath "//tbody/tr"
    -- liftIO.print $ results


{-

isUsernameValid :: Text -> Req Bool
isUsernameValid username = do
    r <- req GET (https "twitter.com" /: username)tor tor -HTTPTunnelPort 8118 NoReqBody bsResponse mempty
    return $ 200 == responseStatusCode r

doesUserExist :: Text -> IO Bool
doesUserExist = runReq myHttpConfig . isUsernameValid

-}

-- main :: IO ()
-- main = mapM_ (prettyPrintDoesUserExist >=> putStrLn . unpack) usernames