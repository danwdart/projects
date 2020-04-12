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

-- This is the group channel
channelId :: ChannelId
channelId = 617861907050659850

handleStart :: DiscordHandle -> IO ()
handleStart h = do
    putStrLn "Start handler called"
    -- Right user <- restCall h R.GetCurrentUser
    -- channel <- restCall h (R.GetChannel channelId)
    void $ sendMessage h "-- Arrr, I be here! --"

type Token = Text
type Username = Text
type MessageText = Text
type MessageResult = Either RestCallErrorCode Message
type MState = [(Int, (String, String))]

sendMessage :: DiscordHandle -> MessageText -> IO MessageResult
sendMessage h msg = do
    putStrLn $ "Sending a message to channel " <> show channelId
    restCall h . R.CreateMessage channelId $ msg

indexList :: [a] -> [(Int, a)]
indexList x = indexList' x $ length x

indexList' :: [a] -> Int -> [(Int, a)]
indexList' [] _ = []
indexList' (a:as) total = (total - length as, a):indexList' as total

getQuery :: IORef MState -> DiscordHandle -> Text -> IO ()
getQuery ir h query = do
    _ <- sendMsg $ "Yarrrr, I be gettin' " <> query <> " for ye!"
    results <- queryPirate query
    _ <- sendMsg $ "Yarrrr, I got ye ' " <> query <> " for ye!"
    _ <- liftIO $ writeIORef ir (indexList results)
    _ <- sendMsg $ "Yarrrr, I stored ye ' " <> query <> " for ye! Here they be:"
    mapM_ (\(ix, (name, _)) -> void $ sendMsg . T.pack $ show ix <> ": " <> name) $
        take 10 (indexList results)
    void . sendMsg $ "Yarr, that be it! Ye can pick! Ye say fer example 'dl 2' to get ye yer second entry! Arr!"
    where
        sendMsg = sendMessage h

parseMsg :: IORef MState -> DiscordHandle -> Text -> Text -> IO ()
parseMsg ir h query = \case
    "get" -> getQuery ir h query
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
        sendMsg = sendMessage h

handleMessage :: IORef MState -> DiscordHandle -> Username -> MessageText -> IO ()
handleMessage ir h username = \case
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
        parseMsg ir h query cmd
    where
        sendMsg = sendMessage h

handleEvent :: IORef MState -> DiscordHandle -> Event -> IO ()
handleEvent ir h = \case
    MessageCreate m -> do
        let author = messageAuthor m
        -- let isBot = userIsBot author
        let msg = messageText m
        let username = userName author
        putStrLn $ username <> " said: " <> msg
        handleMessage ir h username msg
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

runDiscordOpts :: IORef MState -> Token -> RunDiscordOpts
runDiscordOpts ir token = RunDiscordOpts {
    discordToken = token,
    discordOnStart = handleStart,
    discordOnEnd = handleQuit,
    discordOnEvent = handleEvent ir,
    discordOnLog = putStrLn,
    discordForkThreadForEvents = False
}

main :: IO ()
main = void $ runExceptT (
    catchE (
        do
            putStrLn "Dubloons v0.1"
            putStrLn "Loading auth token"
            token <- ExceptT (tryJust (guard . isDoesNotExistError) (getEnv "DISCORD_AUTH_TOKEN"))
            putStrLn "Starting bot"
            stateM <- liftIO . newIORef $ []
            _ <- liftIO . runDiscord . runDiscordOpts stateM . T.pack $ token
            putStrLn "Bot stopped"
        ) (
        const $ putStrLn "Failed to get the authentication token. Please set the environment variable DISCORD_AUTH_TOKEN to your token. See https://github.com/aquarial/discord-haskell/wiki/Creating-your-first-Bot for more details.")
    )