{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

-- Stolen from Matt Parker.

import Data.ByteString.Char8 qualified as B
import Data.Text             (Text)
import Data.Text             qualified as T
import Data.Text.Encoding    qualified as TE

main ∷ IO ()
main = pure ()

-- | Definitions

-- | Keyboard layouts.

-- | Get the word list.
wordList ∷ IO [Text]
wordList = T.words . TE.decodeUtf8Lenient <$> B.readFile "words"

-- | For a list of somethings and their attribute, get the something for the closest attribute.

-- | Determine the "length" of a word.

-- | Determine the average length per distance between letters for a word.

-- | Determine the "pointiness" of a word.

-- | Determine the "shortest" word(s) in the word list

-- | Determine the "longest" word(s) in the word list

-- | Determine the "shortest average" word(s) in the word list

-- | Determine the "longest average" word(s) in the word list.

-- | Determine the "pointiest" word(s) in the word list.

-- | Determine the "least pointy" word(s) in the word list.

-- | Determine the "most right-angled" word(s) in the word list.

-- | Determine the "most turning" word(s) in the word list.

-- | Determine the "most bouncy" (i.e. minimum) in the word list.
