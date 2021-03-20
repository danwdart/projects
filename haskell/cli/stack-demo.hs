#!/usr/bin/env stack
-- stack --resolver nightly-2020-12-03 script

{-# LANGUAGE OverloadedLists #-}

import Data.Map ( Map )

g :: Map Int Int
g = [(1,1)]

main :: IO ()
main = do
    print g
    putStrLn "Hello!"