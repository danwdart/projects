module Main (main) where

-- import Control.Monad
import System.Environment
import Data.Char
import Numeric

main :: IO ()
main = print =<< r where
    r :: IO (Maybe Int)
    r = fffsi fma
    fff = fmap fmap fmap
    fma = fmap (maybeIndex 0) getArgs
    fffsi = fff stringToInteger
    maybeIndex :: Int -> [a] -> Maybe a
    maybeIndex index xs = if null xs then Nothing else Just $ xs !! index
    stringToInteger :: String -> Int
    stringToInteger string = fst $ head (readHex $ concatMap ((`showHex` "") . ord) (filter (/= ' ') string) )
