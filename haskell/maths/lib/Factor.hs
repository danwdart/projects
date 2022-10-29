module Factor where

divides :: Integer -> Integer -> Bool
divides a b = b `mod` a == 0

-- >>> factors 24

factors :: Integer -> [Integer]
factors n = filter (`divides` n) [1..n]