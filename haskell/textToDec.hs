module Main (main) where

import Control.Monad
import System.Environment
import Data.Char
import Numeric

maybeIndex :: Int -> [a] -> Maybe a
maybeIndex index xs = if 0 == length xs then Nothing else Just $ xs !! index

stringToInteger :: String -> Integer
stringToInteger string = fst $ (readHex $ concatMap (\x -> showHex x "") $ map ord $ filter notSpaces string ) !! 0 where
    notSpaces = (/=' ')

args = return ["Foo"] :: IO [String]

foo :: IO [String] -> IO (Maybe String)
foo arggs = fmap (maybeIndex 0) arggs

innerFmap :: (Functor f1, Functor f2) => (a -> b) -> f1 (f2 a) -> f1 (f2 b)
innerFmap = fmap fmap fmap

bar :: IO (Maybe String) -> IO (Maybe Integer)
bar = innerFmap stringToInteger

main :: IO ()
main = fmap show (bar $ foo getArgs) >>= putStrLn
