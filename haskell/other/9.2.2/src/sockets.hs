{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

import           Control.Concurrent        (forkFinally, threadDelay)
import           Control.Concurrent.Async  (concurrently_)
import qualified Control.Exception         as E
import           Control.Monad             (forever, unless, void)
import qualified Data.ByteString           as S
import qualified Data.ByteString.Char8     as C
import           Network.Socket
import           Network.Socket.ByteString (recv, sendAll)

server ∷ IO ()
server = do
    addr <- resolve "3000"
    E.bracket (open addr) close loop
  where
    resolve port = do
        let hints = defaultHints {
                addrFlags = [AI_PASSIVE]
              , addrSocketType = Stream
              }
        addr:_ <- getAddrInfo (Just hints) Nothing (Just port)
        pure addr
    open addr = do
        sock <- socket (addrFamily addr) (addrSocketType addr) (addrProtocol addr)
        setSocketOption sock ReuseAddr 1
        -- If the prefork technique is not used,
        -- set CloseOnExec for the security reasons.
        withFdSocket sock setCloseOnExecIfNeeded
        bind sock (addrAddress addr)
        listen sock 10
        pure sock
    loop sock = forever $ do
        (conn, peer) <- accept sock
        putStrLn $ "Connection from " <> show peer
        void $ forkFinally (talk conn) (\_ -> close conn)
    talk conn = do
        msg <- recv conn 1024
        unless (S.null msg) $ do
          sendAll conn msg
          talk conn

client ∷ IO ()
client = do
    addr <- resolve "127.0.0.1" "3000"
    E.bracket (open addr) close talk
  where
    resolve host port = do
        let hints = defaultHints { addrSocketType = Stream }
        addr:_ <- getAddrInfo (Just hints) (Just host) (Just port)
        pure addr
    open addr = do
        sock <- socket (addrFamily addr) (addrSocketType addr) (addrProtocol addr)
        connect sock $ addrAddress addr
        pure sock
    talk sock = do
        sendAll sock "Hello, world!"
        msg <- recv sock 1024
        putStr "Received: "
        C.putStrLn msg

main ∷ IO ()
main = concurrently_ server (threadDelay 1000 >> client)
