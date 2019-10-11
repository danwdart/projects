{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralisedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE OverloadedStrings          #-}
module Main where

import           Control.Monad
import           Control.Monad.IO.Class
import           Data.Aeson
import qualified Data.ByteString.Char8      as BS
import qualified Data.ByteString.Lazy.Char8 as LBS
import           Data.Function
import           Data.Functor
import           Data.List
import           Data.Maybe
import           Data.Text                  (Text)
import qualified Data.Text                  as T
import qualified Data.Vector                as V
import           Debug.Trace
import           GHC.Generics
import           Network.HTTP.Req
import           Safe                       (headMay)
import           System.Environment
import           System.Random

(<<&>>) :: (Functor f1, Functor f2) => f1 (f2 a) -> (a -> b) -> f1 (f2 b)
(<<&>>) = flip $ (<$>) . (<$>)

-- Let's do omegle with pure stdin/stdout

-- endpoint :: Url Http'
endpoint = http "front4.omegle.com"

userAgent :: BS.ByteString
userAgent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"

headers = header "Referer" "http://www.omegle.com/" <>
    header "User-Agent" userAgent <>
    header "Cache-Control" "no-cache" <>
    header "Origin" "http://www.omegle.com" <>
    header "Accept" "application/json" <>
    header "Content-Type" "application/x-www-form-urlencoded; charset=UTF-8"

likes :: IO [String]
likes = getArgs <&> headMay <<&>> words <&> concat

randid :: IO String
randid = replicateM 7 $ randomRIO ('A', 'Z')

loginQuery :: IO (Option 'Http)
loginQuery = do
    rand <- randid
    likesList <- likes
    return $ "rcs" =: ("1" :: String) <>
        "firstevents" =: ("1" :: String) <>
        queryFlag "spid" <>
        "randid" =: rand <>
        "topics" =: (LBS.unpack . encode $ likesList :: String) <>
        "lang" =: ("en" :: String)

type EventType = String
type MessageBody = String

data Message = Single {
    msg :: MessageBody
} | Multi {
    msgs :: [MessageBody]
} | NoMessageBody deriving (Eq, Generic, Show)

instance FromJSON Message where
    parseJSON = genericParseJSON defaultOptions { unwrapUnaryRecords = True }

type CommonLike = String

-- MessageEvent | LikesEvent etc?
data Event = Event {
    eventName :: EventType,
    eventBody :: Message
} deriving (Eq, Generic, Show)

instance FromJSON Event where
    parseJSON = \case
        (Array a) -> case V.toList a of
            [String a] -> return $ Event (T.unpack a) NoMessageBody
            [String a, String b] -> return $ Event (T.unpack a) (Single (T.unpack b))
            [String a, Array b] -> case V.toList b of
                [String c, String d] -> return $ Event (T.unpack a) (Multi [(T.unpack c), (T.unpack d)])
                [String e] -> return $ Event (T.unpack a) (Single (T.unpack e))
                _ -> error "Subarray is wrong"
            [String a, String b, String c] -> error $ show $ [a, b, c] <&> T.unpack
            _ -> error "Array is wrong"
        _ -> error "Not array"

data LoginResponse = LoginResponse {
    clientID :: String,
    events   :: [Event]
} deriving (Eq, FromJSON, Generic, Show)

--postReq :: (FromJSON a) => String -> Query -> Req (JsonResponse a)
--postReq urlFragment postQuery = runReq defaultHttpConfig $ req POST (endpoint /: urlFragment) NoReqBody jsonResponse postQuery

login :: IO ()
login = do
    likesList <- likes
    putStrLn $ "Connecting with likes " ++ intercalate ", " likesList
    query <- loginQuery
    reqConnect <- runReq defaultHttpConfig $ req POST (endpoint /: "start") NoReqBody jsonResponse query
    let loginBody = responseBody reqConnect :: LoginResponse
    let clientId = clientID loginBody
    parseEvents clientId (events loginBody)
    doEvents clientId

connected :: IO ()
connected = putStrLn "Connected."

commonLikes :: [String] -> IO ()
commonLikes likes = putStrLn $ "Common likes: " ++ intercalate ", " likes

gotMessage :: String -> IO ()
gotMessage msg = putStrLn $ "Stranger: " ++ msg

parseEvents :: String -> [Event] -> IO ()
parseEvents clientId = mapM_ . parseEvent $ clientId

parseEvent :: String -> Event -> IO ()
parseEvent clientId event = case eventName event of
    "waiting" -> putStrLn "Waiting..."
    "connected" -> connected
    "commonLikes" -> commonLikes . msgs . eventBody $ event
    "typing" -> putStrLn "Stranger typing..."
    "stoppedTyping" -> putStrLn "Stranger stopped typing."
    "gotMessage" -> gotMessage . msg . eventBody $ event
    "strangerDisconnected" -> do
        putStrLn "Stranger disconnected."
        disconnect clientId
    "statusInfo" -> mempty
    "identDigests" -> mempty
    "error" -> do
        putStrLn $ "Error: " ++ (msg . eventBody $ event)

doEvents :: String -> IO ()
doEvents clientId = do
    reqEvents <- runReq defaultHttpConfig $ req POST (endpoint /: "events") (ReqBodyUrlEnc ("id" =: clientId)) jsonResponse headers
    let body = responseBody reqEvents :: [Event]
    parseEvents clientId body
    doEvents clientId

exit :: IO ()
exit = undefined

disconnect :: String -> IO ()
disconnect clientId = do
    reqDisconnect <- runReq defaultHttpConfig $ req POST (endpoint /: "disconnect") (ReqBodyUrlEnc ("id" =: clientId)) ignoreResponse headers
    exit

send :: String -> String -> IO ()
send clientId messageText = do
    reqSend <- runReq defaultHttpConfig $ req POST (endpoint /: "send") (ReqBodyUrlEnc ("id" =: clientId <> "msg" =: messageText)) ignoreResponse headers
    putStrLn $ "You: " ++ messageText

main :: IO ()
main = login
