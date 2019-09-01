module Main (main) where

main :: IO ()
main = print [
    (floor c, floor b, floor a, floor d) |
    a <- [1..100],
    b <- [1..a],
    c <- [1..b],
    d <- [1..100],
    a ** 3 + b ** 3 + c ** 3 == d ** 3 ]