module Main (main) where

trips :: [(Int, Int, Int, Int)]
trips = [
    (floor c, floor b, floor a, floor d) |
    a <- [1..100] :: [Double],
    b <- [1..a] :: [Double],
    c <- [1..b] :: [Double],
    d <- [1..100] :: [Double],
    a ** 3 + b ** 3 + c ** 3 == d ** 3 ]

main :: IO ()
main = print trips
