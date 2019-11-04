{-
data LetterType = TypeVowel Char | TypeConsonant Char deriving (Eq, Show)

instance Ord LetterType where
    compare (TypeVowel b) (TypeVowel d) = compare b d

data LetterLocation = LocVowel Int | LocConsonant Int deriving (Eq, Show)

consonants, vowels :: String
consonants = "bcdfghjklmnpqrstvwxyz"
vowels = "aeiou"

all :: [LetterType]
all = fmap TypeConsonant consonants <> fmap TypeVowel vowels

-- elemIndex - do it in a bifunctorish way?

-}
main :: IO ()
main = undefined