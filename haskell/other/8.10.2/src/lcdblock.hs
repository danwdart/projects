{-# LANGUAGE BinaryLiterals  #-}
{-# LANGUAGE OverloadedLists #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Data.Bits
import           Data.Map

{-
 _
|_|
|_|

-}

lcdBlock :: Map Int Char
lcdBlock = [
    (5, '1'),
    (13, '7'),
    (23, '4'),
    (34, 'r'),
    (43, 'ñ'),
    (48, '1'),
    (51, 'h'),
    (55, 'H'),
    (58, 'F'),
    (62, 'P'),
    (63, 'A'),
    (79, '3'),
    (91, '5'),
    (95, '9'),
    (98, 'c'),
    (99, 'o'),
    (103, 'd'),
    (107, 'ō'),
    (110, '2'),
    (112, 'L'),
    (115, 'b'),
    (117, 'U'),
    (121, 'G'),
    (122, 'E'),
    (123, '6'),
    (125, '0'),
    (126, 'e'),
    (127, '8')
    ]

toLcdBlock :: Int -> String
toLcdBlock n = " " ++
    (if testBit n 3 then "_" else " ") ++
    "\n" ++
    (if testBit n 4 then "|" else " ") ++
    (if testBit n 1 then "_" else " ") ++
    (if testBit n 2 then "|" else " ") ++
    "\n" ++
    (if testBit n 5 then "|" else " ") ++
    (if testBit n 6 then "_" else " ") ++
    (if testBit n 0 then "|" else " ")

printN :: Int -> IO ()
printN n = putStrLn $ show n ++ " is:\n" ++ toLcdBlock n

main :: IO ()
main = mapM_ printN ([1..127] :: [Int])
