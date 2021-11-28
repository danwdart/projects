{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import System.Environment
import Web.JWT

main :: IO ()
main = do
    file <- (!! 2) <$> getArgs 
    putStrLn file