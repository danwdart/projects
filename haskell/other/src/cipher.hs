data LetterType = TypeVowel Char | TypeConsonant Char deriving (Show)

instance Ord LetterType where
    compare (a b) (c d) = compare b d

data LetterLocation = LocVowel Int | LocConsonant Int deriving (Show)

consonants, vowels :: String
consonants = "bcdfghjklmnpqrstvwxyz"
vowels = "aeiou"

all :: [LetterType]
all = fmap TypeConsonant consonants <> fmap TypeVowel vowels

-- elemIndex - do it in a bifunctorish way?

main :: IO ()
main = undefined