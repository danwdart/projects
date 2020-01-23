{-# LANGUAGE DeriveAnyClass, DeriveFunctor, GeneralisedNewtypeDeriving #-}

import Data.Char
-- import Text.Parsec

main :: IO ()
main = return ()

type ParseResult a = (Maybe a, String)

newtype Parser a = Parser {
    runParser :: String -> ParseResult a
} deriving (Functor, Applicative)

matchCharFn :: (Char -> Bool) -> String -> ParseResult Char
matchCharFn fn (x:xs)
    | fn x = (Just x, xs)
    | otherwise = (Nothing, xs)

matchChar :: Char -> String -> ParseResult Char
matchChar = matchCharFn . (==)

matchAlpha :: String -> ParseResult Char
matchAlpha = matchCharFn isAlpha