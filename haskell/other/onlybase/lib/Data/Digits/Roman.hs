module Data.Digits.Roman where

data RomanNumberCharacter = I | V | X | L | C | D | M

data Roman n where
    Add :: n -> n -> n
    Sub :: n -> n -> n

difference :: Roman -> Roman -> Roman
difference = undefined

add :: Roman -> Roman -> Roman
add = undefined

fromRoman :: Roman -> Int
fromRoman = undefined

toRoman :: Int -> Roman
toRoman = undefined