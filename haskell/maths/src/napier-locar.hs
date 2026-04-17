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


-- Now do the chessboard simulation - ridiculous.

-- How may one render, probably by going [[65536],[32768,32768],[16384,16384,16384]]...

-- are we gonna say it's infinite idk - that means n copies of 2^n-1 or equivalently n+1 copies of 2^n?