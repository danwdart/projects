{-# LANGUAGE OverloadedStrings #-}

import Control.Exception
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Except
import Data.Either
import qualified Data.Text as T (append, pack, unpack)
import Data.Text.IO as TIO (putStrLn, readFile)
import Data.Text (Text)
import Discord
import qualified Discord.Requests as R
import Discord.Types  (GuildId, ChannelId, Message, Event (..), userId, messageText, userIsBot, userName, messageAuthor)
import System.Environment
import System.IO.Error

guildId :: GuildId
guildId = 507557271191158784

channelId :: ChannelId
channelId = 617861907050659850

handleStart :: DiscordHandle -> IO ()
handleStart h = do
    Prelude.putStrLn "Start handler called"
    Right user <- restCall h (R.GetCurrentUser)
    channel <- restCall h (R.GetChannel channelId)
    void $ sendMessage h "-- Bot Started --"

type Token = Text
type Username = Text
type MessageText = Text
type MessageResult = Either RestCallErrorCode Message

sendMessage :: DiscordHandle -> MessageText -> IO MessageResult
sendMessage h text = restCall h (R.CreateMessage channelId text)

handleMessage :: DiscordHandle -> Username -> MessageText -> IO ()
handleMessage h username messageText = do
    case (T.unpack messageText) of
        "/hello" -> void $ sendMessage h $ "Ahoy, matey!" `T.append` username `T.append` "!"
        "/status" -> void $ sendMessage h $ "Yarr, all hands on deck!"
        "/quit" -> do
            messageEvent <- sendMessage h "Bye, Cap'n!"
            Prelude.putStrLn "Received quit message"
            stopDiscord h
        otherwise ->
            return ()

handleEvent :: DiscordHandle -> Event -> IO ()
handleEvent h e = do
    case e of
        MessageCreate m -> do
            let author = messageAuthor m
            let isBot = userIsBot author
            let msg = messageText m
            let username = userName author
            TIO.putStrLn $ username `T.append` (T.pack " said: ") `T.append` msg
            handleMessage h username msg
        otherwise -> do
            Prelude.putStrLn "Event detected. Not handled."

handleQuit :: IO ()
handleQuit = do
    Prelude.putStrLn "Quit handler called"

runDiscordOpts :: Token -> RunDiscordOpts
runDiscordOpts token = RunDiscordOpts {
    discordToken = token,
    discordOnStart = handleStart,
    discordOnEnd = handleQuit,
    discordOnEvent = handleEvent,
    discordOnLog = TIO.putStrLn,
    discordForkThreadForEvents = False
}

main :: IO ()
main = do
    runExceptT (catchE ( do
        liftIO . Prelude.putStrLn $ "Dubloons v0.1"
        liftIO . Prelude.putStrLn $ "Loading auth token"
        token <- ExceptT (tryJust (guard . isDoesNotExistError) (getEnv "DISCORD_AUTH_TOKEN"))
        liftIO . Prelude.putStrLn $ "Starting bot"
        liftIO . runDiscord . runDiscordOpts . T.pack $ token
        liftIO . Prelude.putStrLn $ "Bot stopped"
        return "OK"
        ) (
        (\e -> do
            liftIO . Prelude.putStrLn $ "Failed to get the authentication token. Please set the environment variable DISCORD_AUTH_TOKEN to your token. See https://github.com/aquarial/discord-haskell/wiki/Creating-your-first-Bot for more details."
            return "OK"
        )))
    return ()