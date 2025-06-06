module Main (main) where

import Data.Foldable
import Numeric.Napier

-- Words which are in alphabetical order (either) and with no repeats.
alphabeticalWords ∷ [String]
alphabeticalWords = [
    "abhors",
    "almost",
    "begin",
    "begins",
    "biopsy",
    "chimp",
    "chimps",
    "chintz",
    "forty",
    "sponge",
    "sponged",
    "wronged"
    ]

main ∷ IO ()
main = traverse_ (\word ->
    putStrLn $ "The word " <> word <> " translated to Napier notation is equal to the value " <> show (symToInt word)
    ) alphabeticalWords
