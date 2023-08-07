module Main where

import           MyHandler
import           Network.DigitalOcean.CloudFunctions.Handler

main :: IO ()
main = handle myHandler