module Main where

main :: IO ()
main = pure ()

-- 0-99: 10 1 9 2 8 3 7 4 6 5 5 6 4 7 3 8 2 9 1, 11 9 2 8 3 7 4 ...
-- 12 

-- 0..9 1 11..19 2 22..29 3 33..39 44..49 55..59 66..69 77..79 88..89 99 111-119, 122-129
takeDropList :: [Integer]
takeDropList = [9,1,10]

nonDecreasing :: [Integer]
nonDecreasing = undefined