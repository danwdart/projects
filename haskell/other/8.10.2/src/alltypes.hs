module Main (main) where

import           Data.List

nl :: String
nl = "\n"

{-
c_type :: String
c_type = ":t"

c_comb :: String
c_comb = "(.)"

toRight :: Int -> String -> String
toRight n what = c_type ++ " " ++ (concat $ intersperse (nl ++ c_type ++ " ") $ take n $ drop 1 $ iterate (++ "" ++ what) "")

toLeft :: Int -> String -> String
toLeft n what = c_type ++ " " ++ (concat $ intersperse (nl ++ c_type ++ " ") $ take n $ drop 1 $ iterate (\s -> what ++ "(" ++ s ++ ")") what)
-}

namesFor :: String -> Int -> Int -> Int -> String
namesFor s_type a b c = show a ++ s_type ++
 show b ++ "_" ++ show c

right :: Int -> String -> String
right n str = concat $ replicate n ("(" ++ str ++ ")")

left :: Int -> String -> String
left 1 str = str
left n str = str ++ "(" ++ left (n-1) str ++ ")"

fnFor :: String -> Int -> Int -> Int -> String
fnFor s_type a b c = right c (left a (right b s_type))

assign :: String -> String -> Int -> Int -> Int -> String
assign s_type f_type a b c = "c_" ++ namesFor s_type a b c ++ " = " ++ fnFor f_type a b c

breakWithNLs :: [String] -> String
breakWithNLs = intercalate nl

as, bs, cs :: [Int]
as = [1..10]
bs = [1..9]
cs = [1..9]

assignAll :: String
assignAll = breakWithNLs [assign "C" "(.)" a b c | a <- as, b <- bs, c <- cs]

typesAll :: String
typesAll = breakWithNLs [":t c_" ++ namesFor "C" a b c | a <- as, b <- bs, c <- cs]

result :: String
result = assignAll ++ "\n" ++ typesAll

main :: IO ()
main = putStrLn result
