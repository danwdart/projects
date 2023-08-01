{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BSL
import           System.Environment

import qualified MyLib                      (someFunc)

main :: IO ()
main = do
  args <- getArgs

  let a = decode (BSL.pack (head args)) :: Maybe Object
  putStrLn "{\"message\":\"Hello, Haskell!\"}"
  -- MyLib.someFunc
