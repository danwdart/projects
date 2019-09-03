{-# LANGUAGE OverloadedStrings #-}

import Control.Monad
import qualified Data.Text as T (append, pack, unpack)
import Data.Text.IO as TIO (putStrLn, readFile)
import Data.Text (Text)
import Discord
import qualified Discord.Requests as R
import Discord.Types  (GuildId, ChannelId, Message, Event (..), userId, messageText, userIsBot, userName, messageAuthor)
import Prelude hiding (putStrLn)

guildId :: GuildId
guildId = 507557271191158784

channelId :: ChannelId
channelId = 617861907050659850

handleStart :: DiscordHandle -> IO ()
handleStart h = do
    putStrLn "Start handler called"
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
            putStrLn "Received quit message"
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
            putStrLn $ username `T.append` (T.pack " said: ") `T.append` msg
            handleMessage h username msg
        otherwise -> do
            putStrLn "Event detected. Not handled."

handleQuit :: IO ()
handleQuit = do
    putStrLn "Quit handler called"

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
    putStrLn "Dubloons v0.1"
    putStrLn "Loading auth token"
    token <- TIO.readFile "auth-token.secret"
    putStrLn "Starting bot"
    runDiscord $ runDiscordOpts token
    putStrLn "Bot stopped"