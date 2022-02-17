{-# OPTIONS_GHC -Wno-unused-matches -Wno-unused-top-binds #-}


-- @TODO make negabinary work?
hundreds, tens, units :: [(Int, String)]
hundreds = [
    (300, "trecente"), -- or trecento if 300
    (200, "duocente"),
    (100, "cente")
    ]

tens = (10, "decimal") : fmap (fmap (++ "gesimal")) [
    (20, "vi"),
    (30, "tri"),
    (40, "quadra"),
    (50, "quinqua"),
    (60, "sexa"),
    (70, "septua"),
    (80, "octo"),
    (90, "nona")
    ]

units = [
    (1, "un"),
    (2, "duo"),
    (3, "tri"),
    (4, "tetra"),
    (5, "penta"),
    (6, "hexa"),
    (7, "hepta"),
    (8, "octo"),
    (9, "ennea")
    ]

numToName :: Int -> String
numToName = undefined

nameToNum :: String -> Int
nameToNum = undefined

-- @TODO TH the below wit the above
-- https://en.wikipedia.org/wiki/List_of_numeral_systems#Standard_positional_numeral_systems
bin, binary, ternary, quaternary, quinary, senary, septenary, oct, octal, nonary, dec, decimal, dozenal, hex, hexadecimal :: Integer
bin = 2
binary = 2
ternary = 3
quaternary = 4
quinary = 5
senary = 6
septenary = 7
oct = 8
octal = 8
nonary = 9
dec = 10
decimal = 10
dozenal = 12
hex = 16
hexadecimal = 16

type Notation = String

base36LowerNotation, base36UpperNotation, hexLowerNotation, hexUpperNotation, swedenborgUNotation, swedenborgVNotation, dozenalABNotation, dozenalUSNotation, dozenalGBNotation, binaryDotNotation :: Notation
base36LowerNotation = ['0'..'9'] <> ['a'..'z']
base36UpperNotation = ['0'..'9'] <> ['A'..'Z']
-- @TODO TH the below using the above
hexLowerNotation = take 16 base36LowerNotation
hexUpperNotation = take 16 base36UpperNotation
-- https://en.wikipedia.org/wiki/Octal
swedenborgUNotation = "olsnmtfu"
swedenborgVNotation = "olsnmtfv"
dozenalABNotation = take 12 base36UpperNotation
dozenalUSNotation = ['0'..'9'] <> "XE"
dozenalGBNotation = ['0'..'9'] <> "↊↋"
binaryDotNotation = " ."

type ErrorMessage = String

toBase :: Integer -> Integer -> [Integer]
toBase b n = m : if d == 0 then [] else toBase b d
    where (d, m) = divMod n b

fromBase :: Integer -> [Integer] -> Integer
fromBase _ []     = 0
fromBase b (n:ns) = n + b * fromBase b ns

fromBaseStrict :: Integer -> [Integer] -> Maybe Integer
fromBaseStrict = undefined

(!?) :: [a] -> Integer -> Maybe a
xs !? i = if length xs < fromIntegral (i + 1) then Nothing else Just $ xs !! fromIntegral i

renderBase :: Notation -> [Integer] -> Either ErrorMessage String
renderBase _ [] = Right ""
renderBase notation (x:xs) = case notation !? x of
    Nothing -> Left $ "No known notation for " <> show x <> " in set (" <> notation <> ")"
    Just char -> (<> [char]) <$> renderBase notation xs

parseStrIn :: Integer -> Notation -> Either ErrorMessage [Integer]
parseStrIn = undefined

main :: IO ()
main = do
    print . fromBase 2 $ toBase 2 129
    print . renderBase base36LowerNotation $ toBase 8 123
    print . renderBase swedenborgUNotation $ toBase 8 512
    print . renderBase base36UpperNotation $ toBase 16 1000
    print . renderBase dozenalGBNotation $ toBase 12 2012
    print . renderBase binaryDotNotation $ toBase 2 12087
    print . renderBase binaryDotNotation $ toBase 18 1963
