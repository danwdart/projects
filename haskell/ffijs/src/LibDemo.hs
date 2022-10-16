{-# LANGUAGE JavaScriptFFI #-}

module LibDemo where

import           Control.Monad ((>=>))
import           Foreign.C     (CString, newCString, peekCString)

-- This is just a function that returns some data. There's probably no plain string.
dataraw :: Int
dataraw = 42

-- This is just a function that returns some data. There's probably no plain string.
datas :: IO CString
datas = newCString "Data"

fn :: CString -> IO CString
fn = peekCString >=> pure . (<> "!") >=> newCString

-- Alternatively arrowly written as:
-- import Control.Arrow
-- fnA :: CString -> IO CString
-- fnA = runKleisli $ Kleisli peekCString <<< Kleisli (pure . (<> "!")) <<< Kleisli newCString

io :: IO ()
io = putStrLn "Hello from Haskell!"

add :: Int -> Int
add = (+ 42)

foreign export javascript "dataraw" dataraw :: Int
foreign export javascript "datas" datas :: IO CString
foreign export javascript "fn" fn :: CString -> IO CString
foreign export javascript "io" io :: IO ()
foreign export javascript "add" add :: Int -> Int
