module Main where

import Data.DateTime (getCurrentTime)
import Funk.Utils (untilEnd)

main :: IO ()
main = do
    now <- getCurrentTime
    mapM_ putStrLn $ untilEnd now