module Main (main) where

-- import Control.Monad
import System.Environment
import Data.Char
import Numeric

main :: IO ()
main = fmap show r >>= putStrLn where
    r :: IO (Maybe Int)
    r = fffsi fma
    fff = fmap fmap fmap
    fma = fmap (maybeIndex 0) getArgs
    fffsi = fff stringToInteger
    maybeIndex :: Int -> [a] -> Maybe a
    maybeIndex index xs = if 0 == length xs then Nothing else Just $ xs !! index
    stringToInteger :: String -> Int
    stringToInteger string = fst $ (readHex $ concatMap (\x -> showHex x "") $ map ord $ filter (/=' ') string ) !! 0