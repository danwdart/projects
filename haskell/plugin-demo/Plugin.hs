{-# LANGUAGE CApiFFI #-}
{-# LANGUAGE OverloadedStrings #-}
-- TODO foreign export?

module Plugin where

import Foreign.C
import Foreign.C.String

initialise :: IO ()
initialise = putStrLn "Hello World"

printversion :: IO ()
printversion = putStrLn "Version 1"

magic_number :: Int
magic_number = 1

version :: IO CString
version = newCString "2"

getversion :: IO CString
getversion = newCString "2"

deinitialise :: IO ()
deinitialise = putStrLn "Goodbye World"

-- etc.

foreign export capi "initialise" initialise :: IO ()
foreign export capi "printversion" printversion :: IO ()
foreign export capi "magic_number" magic_number :: Int -- CInt? Different name?
foreign export capi "version" version :: IO CString
foreign export capi "getversion" getversion :: IO CString
foreign export capi "deinitialise" deinitialise :: IO ()