{-# LANGUAGE LambdaCase, OverloadedStrings #-}
{-# OPTIONS_GHC -Wall -Werror -Wno-type-defaults -Wno-unused-imports #-}

import Data.IORef
import Control.Exception
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.State
import Control.Monad.Trans.Except
import Data.Either
import Data.Text (Text)
import qualified Data.Text as T
import Discord
import qualified Discord.Requests as R
import Discord.Types hiding (channelId)
import Lib.Prelude
import Lib.Pirate
import Prelude hiding (putStrLn, print)
import System.Environment
import System.IO.Error
import System.Process

-- guildId :: GuildId
-- guildId = 507557271191158784

handleStart :: ChannelId -> DiscordHandle -> IO ()
handleStart channelId h = do
    putStrLn "Start handler called"
    -- Right user <- restCall h R.GetCurrentUser
    -- channel <- restCall h (R.GetChannel channelId)
    void $ sendMessage h channelId "-- Arrr, I be here! --"

type Token = Text
type Username = Text
type MessageText = Text
type MessageResult = Either RestCallErrorCode Message
type MState = [(Int, (String, String))]

sendMessage :: DiscordHandle -> ChannelId -> MessageText -> IO MessageResult
sendMessage h channelId msg = do
    putStrLn $ "Sending a message to channel " <> show channelId
    restCall h . R.CreateMessage channelId $ msg

indexList :: [a] -> [(Int, a)]
indexList x = indexList' x $ length x

indexList' :: [a] -> Int -> [(Int, a)]
indexList' [] _ = []
indexList' (a:as) total = (total - length as, a):indexList' as total

getQuery :: IORef MState -> DiscordHandle -> ChannelId -> Text -> Text -> IO ()
getQuery ir h channelId hostname query = do
    _ <- sendMsg $ "Yarrrr, I be gettin' " <> query <> " for ye!"
    results <- queryPirate hostname query
    _ <- sendMsg $ "Yarrrr, I got ye ' " <> query <> " for ye!"
    _ <- liftIO $ writeIORef ir (indexList results)
    _ <- sendMsg $ "Yarrrr, I stored ye ' " <> query <> " for ye! Here they be:"
    mapM_ (\(ix, (name, _)) -> void $ sendMsg . T.pack $ show ix <> ": " <> name) $
        take 10 (indexList results)
    void . sendMsg $ "Yarr, that be it! Ye can pick! Ye say fer example 'dl 2' to get ye yer second entry! Arr!"
    where
        sendMsg = sendMessage h channelId

parseMsg :: IORef MState -> ChannelId -> DiscordHandle -> Text -> Text -> Text -> IO ()
parseMsg ir channelId h hostname query = \case
    "get" -> getQuery ir h channelId hostname query
    "results" -> do
        v <- liftIO . readIORef $ ir
        void $ sendMsg (T.pack $ show (map (\(i, (n, _)) -> (i, n)) v))
    "dl" -> do
        v <- liftIO . readIORef $ ir
        let result = snd <$> lookup (read . T.unpack $ query) v
        -- void . sendMsg . T.pack $ show $ result) v
        maybe (void $ sendMsg "Yarr, that weren't existin'!") (\r -> do
            _ <- sendMsg "Yarr, I be spawnin' yer download!"
            _ <- liftIO . spawnCommand $ "ktorrent -- '" <> r <> "'"
            void $ sendMsg "Yarr, I spawned yer download!"
            ) result
    _ -> return ()
    where
        sendMsg = sendMessage h channelId

handleMessage :: IORef MState -> ChannelId -> DiscordHandle -> Username -> Text -> MessageText -> IO ()
handleMessage ir channelId h username hostname  = \case
    "/hello" -> void $ sendMsg $ "Ahoy, matey, " <> username <> "!"
    "/status" -> void $ sendMsg "Yarr, all hands on deck!"
    "/help" -> void $ sendMsg $ "Arr, ye can say:\n" <>
        "/hello - I be doin' an echo!\n" <>
        "/status - I tell ye how I be doin'!\n" <>
        "/help - This!\n" <>
        "/quit - I say bye cap'n!"
    "/quit" -> do
        _ <- sendMsg "Bye, Cap'n!"
        putStrLn "Received quit message"
        stopDiscord h
    msg -> do
        let (cmd : queries) = T.words msg
        let query = T.unwords queries
        parseMsg ir channelId h hostname query cmd
    where
        sendMsg = sendMessage h channelId

handleEvent :: IORef MState -> ChannelId -> Text -> DiscordHandle -> Event -> IO ()
handleEvent ir channelId hostname h = \case
    MessageCreate m -> do
        let author = messageAuthor m
        -- let isBot = userIsBot author
        let msg = messageText m
        let username = userName author
        putStrLn $ username <> " said: " <> msg
        handleMessage ir channelId h username hostname msg
    Ready {} -> putStrLn "Received Ready event."
    GuildCreate {} -> putStrLn "Received GuildCreate event."
    ChannelCreate ChannelDirectMessage {} -> putStrLn "Received ChannelCreate - direct message event."
    TypingStart _ -> putStrLn "A user is typing."
    PresenceUpdate _ -> putStrLn "Received Presence update event."
    MessageReactionAdd _ -> putStrLn "Received a reaction event."
    m -> do
        putStrLn "Event detected. Not handled."
        print m

handleQuit :: IO ()
handleQuit = putStrLn "Quit handler called"

runDiscordOpts :: IORef MState -> Token -> ChannelId -> Text -> RunDiscordOpts
runDiscordOpts ir token channelId hostname = RunDiscordOpts {
    discordToken = token,
    discordOnStart = handleStart channelId,
    discordOnEnd = handleQuit,
    discordOnEvent = handleEvent ir channelId hostname,
    discordOnLog = putStrLn,
    discordForkThreadForEvents = False
}

main :: IO ()
main = void $ runExceptT $ do
    putStrLn "Dubloons v0.1"
    putStrLn "Loading auth token"
    token <- catchE (ExceptT (tryJust (guard . isDoesNotExistError) (getEnv "DISCORD_AUTH_TOKEN"))) $
        fail "Failed to get the authentication token. Please set the environment variable DISCORD_AUTH_TOKEN to your token & make sure you include DISCORD_CHANNEL_ID. See https://github.com/aquarial/discord-haskell/wiki/Creating-your-first-Bot for more details."
    channelId <- catchE (ExceptT (tryJust (guard . isDoesNotExistError) (getEnv "DISCORD_CHANNEL_ID"))) $
        fail "Failed to get the channel ID. Please set the environment variable DISCORD_CHANNEL_ID."
    hostname <- catchE (ExceptT (tryJust (guard . isDoesNotExistError) (getEnv "TPB_DOMAIN"))) $
        fail "Failed to get the TPB domain. Please set the environment variable TPB_DOMAIN."
    putStrLn "Starting bot"
    stateM <- liftIO . newIORef $ []
    _ <- liftIO . runDiscord $ runDiscordOpts stateM (T.pack token) (fromIntegral $ read channelId) (T.pack hostname)
    putStrLn "Bot stopped"