{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-matches #-}

-- Make a game. Make guesses. See what guessing strategy is best.

-- template and guesses are state
-- word is reader
-- debug is writer

-- use index.
-- use standard indexed / array

wordlist ∷ String
wordlist = "https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt"

turns ∷ Int
turns = 10

start ∷ String → (String, String, String)
start s = (s, '_' <$ s, "")

setAt ∷ Int → a → [a] → [a]
setAt n c s = undefined

wheres ∷ a → [a] → [Int]
wheres c s = undefined

orderedFrequencies ∷ [[a]] → [a]
orderedFrequencies xs = undefined

memoiseFSRW ∷ (Show a, Read a) ⇒ FilePath → Maybe a → IO a
memoiseFSRW = undefined

writeToFile ∷ (Show a) ⇒ FilePath → a → IO ()
writeToFile = undefined

readFromFile ∷ (Read a) ⇒ FilePath → a → IO ()
readFromFile = undefined

guess ∷ Char → (String, String, String) → (String, String, String)
guess g (word, template, wrongs) =
    if g `elem` word
        then (word, template, wrongs)
        else (word, template, wrongs <> [g])

main ∷ IO ()
main = pure ()
