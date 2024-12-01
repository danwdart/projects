{-# LANGUAGE ApplicativeDo   #-}
{-# LANGUAGE DeriveAnyClass  #-}
{-# LANGUAGE OverloadedLists #-}

module Word where

import Control.Monad.Random
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer
import Data.Aeson
import GHC.Generics

data Letter = Vowel | Consonant deriving (Eq, Show, Enum, Bounded)

data Letters = Letters {
    vowels     :: [String],
    consonants :: [String]
}

instance FromJSON Letters where
    parseJSON (Array [v, c]) = Letters <$> parseJSON v <*> parseJSON c
    parseJSON x = fail $ "Can't decode: " <> show x

data Phonemes = Phonemes {
    start  :: Letters,
    middle :: Letters,
    end    :: Letters
}
    deriving stock (Generic)
    deriving anyclass (FromJSON)

switch ∷ Letter → Letter
switch Vowel     = Consonant
switch Consonant = Vowel

-- pick :: MonadRandom m => m Letter
-- pick = uniform

mkWord ∷ (MonadRandom m, MonadReader Phonemes m) ⇒ m String
mkWord = do
    letter <- _
    concat <$> execWriter $ evalState letter genWord

genWord ∷ (MonadReader Phonemes m, MonadState Letter m, MonadWriter [String] m) ⇒ Int → m ()
genWord length = do
    letter <- get
    tell ["a"]

{-
var pick = function (arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

module.exports = function Word(nPhonemes, phonemes)
{
    var word = '',
        // Choose vowel or consonant
        current = pick([0,1]);

    for (var i = 1; i <= nPhonemes; i++) {
        var set = (1 == i)?'start':((nPhonemes == i)?'end':'middle');
        // Append a random letter
        word += pick(phonemes[set][current]);
        // and flip the bit so we pick the other next time
        current = Number(!current);
    }

    return word;
};
-}
