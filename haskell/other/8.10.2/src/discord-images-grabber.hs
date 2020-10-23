{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import Control.Concurrent
import Control.Concurrent.Chan
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader
import qualified Data.ByteString.Char8 as B
import Data.Maybe
import qualified Data.Text as T
import Data.Text.Encoding
import Discord
import Discord.Internal.Rest
import Discord.Internal.Rest.Prelude
import Discord.Requests
import Discord.Types
import Network.HTTP.Client hiding (queryString)
import Network.HTTP.Client.TLS
import Network.HTTP.Req
import Network.HTTP.Types.Status
import Network.OAuth.OAuth2
import Network.Wai
import Network.Wai.Handler.Warp
import URI.ByteString
import URI.ByteString.QQ

-- no RPC !!
main :: IO ()
main = do
    let scope = "identify%20guilds%20messages.read"
    let redirectUri = [uri|http://localhost:7979|]
    let authEP = [uri|https://discord.com/api/oauth2/authorize|]
    let atEP = [uri|https://discord.com/api/oauth2/token|]
    let oauth2 = OAuth2 {
        oauthClientId = "760419848521515028",
        oauthClientSecret = Just "C19q_B-b5S-E_dUTl6g4hp6PE0qHz8iq",
        oauthOAuthorizeEndpoint = authEP, 
        oauthAccessTokenEndpoint = atEP,
        oauthCallback = Just redirectUri
    }
    putStrLn $ B.unpack $ "Go to " <> serializeURIRef' (authorizationUrl oauth2) <> "&scope=" <> scope
    putStrLn "Running web server at http://localhost:7979"
    manager <- newManager tlsManagerSettings
    run 7979 \req res -> do
        let et = ExchangeToken $ decodeUtf8 $ maybe "" (fromMaybe "") (lookup "code" $ queryString req)
        at <- fetchAccessToken manager oauth2 et
        case at of
            Right ot@OAuth2Token {accessToken = AccessToken {atoken}} -> do
                print ot
                print atoken
                t <- runDiscord def {
                    discordToken = "Bearer " <> atoken,
                    discordOnStart = do
                        h <- ask
                        liftIO $ do
                            print "Logged into Discord."
                        dmChans <- restCall GetUserDMs
                        liftIO $ print dmChans,
                    discordOnEnd = do
                        print "Bye bye Discord!",
                    discordOnEvent = \e -> do
                        h <- ask
                        liftIO $ print e,
                    discordForkThreadForEvents = False,
                    discordOnLog = \l -> do
                        print l
                }
                print t
                res $ responseLBS status200 [] "Continuing."
            Left _ -> res $ responseLBS status400 [] "Invalid code."
    putStrLn "Web server closed"

    
    return ()