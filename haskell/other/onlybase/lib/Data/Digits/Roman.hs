module Data.Digits.Roman where

data RomanNumberCharacter = I | V | X | L | C | D | M

data Roman where
    Add :: RomanNumberCharacter -> RomanNumberCharacter -> Roman
    Sub :: RomanNumberCharacter -> RomanNumberCharacter -> Roman

difference ∷ Roman → Roman → Roman
difference = undefined

add ∷ Roman → Roman → Roman
add = undefined

fromRoman ∷ Roman → Int
fromRoman = undefined

toRoman ∷ Int → Roman
toRoman = undefined
