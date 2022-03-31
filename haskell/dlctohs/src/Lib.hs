{-# LANGUAGE CApiFFI #-}

module Lib where

import Foreign.C

-- This is just a function that returns some data. There's probably no plain string.
datas :: IO CString
datas = newCString "Data"

-- @TODO conversions
fn :: CString -> IO CString
fn cstr = do
    str <- peekCString cstr
    let out = "!!" <> str <> "!!"
    putStrLn out
    newCString out
    
io :: IO ()
io = putStrLn "Hello from Haskell!"

add :: Int -> Int
add = (+ 42)

foreign export capi datas :: IO CString
foreign export capi fn :: CString -> IO CString
foreign export capi io :: IO ()
foreign export capi add :: Int -> Int