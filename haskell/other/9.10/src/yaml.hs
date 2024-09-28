{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

-- import Data.ByteString qualified as B
import Data.Yaml

myData ∷ [[String]]
myData = [["Bob", "Jim"], ["Ted"]]

main ∷ IO ()
main = print $ encode myData
