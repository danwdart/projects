{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           System.IO
import           System.Serial
import           System.Serial.BlockingManager as BM
import           System.Serial.Manager         as M

blocking :: Handle -> IO ()
blocking handle = do
    mgr <- M.serialManager handle "\r" "\r"
    rsp <- M.wrapCommand "AT" (=="OK") mgr
    putStrLn rsp
    closeSerialManager mgr

nonBlocking :: Handle -> IO ()
nonBlocking handle = do
    bmgr <- BM.serialManager handle 5000
    brsp <- BM.wrapCommand "\r" "AT" bmgr
    print brsp

raw :: Handle -> IO ()
raw handle = do
    hPutStr handle "AT\r"
    rsp2 <- hGetLine handle
    putStrLn rsp2

main :: IO ()
main = do
    handle <- openSerial "/dev/pts/3" B115200 8 One NoParity Software
    raw handle
    hClose handle
