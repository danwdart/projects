module Main (main) where

import Control.Monad
import System.Environment
import Data.Char
import Numeric

main :: IO ()
main = fmap show (((fmap fmap fmap) stringToInteger) ( fmap (maybeIndex 0) getArgs)) >>= putStrLn where
    maybeIndex index xs = if 0 == length xs then Nothing else Just $ xs !! index
    stringToInteger string = fst $ (readHex $ concatMap (\x -> showHex x "") $ map ord $ filter (/=' ') string ) !! 0