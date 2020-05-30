{-# LANGUAGE OverloadedStrings #-}

-- import qualified Data.ByteString as B
import Data.Yaml

myData :: [[String]]
myData = [["Bob", "Jim"], ["Ted"]]

main :: IO ()
main = print $ encode myData