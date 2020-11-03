{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-orphans #-}

import           Control.Applicative
import           Data.Char
import           Data.Either

main :: IO ()
main = putStrLn $ either show show $ snd <$> runParser strNumJ " { \"bobby mcgoo\" : 66 : 78,09,87,449,3238626433832795028 }"

newtype Parser a = Parser {
    runParser :: String -> Either String (String, a)
}

instance Functor Parser where
    fmap f (Parser p) = Parser $ \input -> do
        (input', x) <- p input
        Right (input', f x)

instance Applicative Parser where
    pure x = Parser $ \input -> Right (input, x)
    (Parser p1) <*> (Parser p2) = Parser $ \input -> do
        (input', f) <- p1 input
        (input'', a) <- p2 input'
        Right (input'', f a)

instance Alternative (Either String) where
    empty = Left "Empty"
    a <|> b = if isLeft a then b else a

instance Alternative Parser where
    empty = Parser $ const $ Left "No input"
    (Parser p1) <|> (Parser p2) = Parser $ \input -> p1 input <|> p2 input

charPFn :: (Char -> Bool) -> Parser Char
charPFn matchFn = Parser f where
    f (x:xs)
        | matchFn x = Right (xs, x)
        | otherwise = Left $ "No match matching " ++ xs ++ " at " ++ [x]
    f [] = Left "No input"

spanP :: (Char -> Bool) -> Parser String
spanP f = Parser $ \input ->
    let (token, rest) = span f input
    in Right (rest, token)

charP :: Char -> Parser Char
charP =  charPFn . (==)

alphaP :: Parser Char
alphaP = charPFn isAlpha

digitP :: Parser Char
digitP = charPFn isNumber

strP :: String -> Parser String
strP = traverse charP

qstrP :: Parser String
qstrP = charP '"' *> spanP (/='"') <* charP '"'

alphaPs :: Parser String
alphaPs = spanP isAlpha

ws :: Parser String
ws = spanP isSpace

ob :: Parser Char
ob = ws *> charP '{' <* ws

cb :: Parser Char
cb = ws *> charP '}' <* ws

cl :: Parser Char
cl = ws *> charP ':' <* ws

sepBy :: Parser a -> Parser b -> Parser [b]
sepBy sep el = (:) <$> el <*> many (sep *> el) <|> pure []

numP :: Parser Int
numP = read <$> spanP isNumber

csvP :: Parser a -> Parser [a]
csvP = sepBy (charP ',')

strNumJ :: Parser (String, Int, [Int])
strNumJ = (\_ a _ b _ c _ -> (a, b, c)) <$>
    ob <*>
    qstrP <*>
    cl <*>
    numP <*>
    cl <*>
    csvP numP <*>
    cb
