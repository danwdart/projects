{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as B
import Data.Yaml

myData :: [[String]]
myData = [["Bob", "Jim"], ["Ted"]]

myEncoded :: B.ByteString
myEncoded = encode myData

main = print myEncoded