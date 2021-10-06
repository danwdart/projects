{-# OPTIONS_GHC -Wno-unused-matches -Wno-unused-top-binds #-}

dec, decimal, bin, binary, hex, hexadecimal, oct, octal, ternary :: Integer
dec = 10
decimal = 10
bin = 2
binary = 2
hex = 16
hexadecimal = 16
oct = 8
octal = 8
ternary = 3

-- @TODO TH these into to/froms

type ErrorMessage = String

toBase :: Integer -> Integer -> [Integer]
toBase b n = m : if d == 0 then [] else toBase b d
    where (d, m) = divMod n b

fromBase :: Integer -> [Integer] -> Integer
fromBase _ [] = 0
fromBase b (n:ns) = n + b * fromBase b ns

fromBaseStrict :: Integer -> [Integer] -> Maybe Integer
fromBaseStrict = undefined

renderBase :: [Integer] -> Either ErrorMessage String
renderBase = undefined

parseStrIn :: Integer -> String -> Either ErrorMessage [Integer]
parseStrIn = undefined

main :: IO ()
main = print $ fromBase 2 $ toBase 2 129