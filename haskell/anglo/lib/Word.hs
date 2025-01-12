{-# LANGUAGE ApplicativeDo   #-}
{-# LANGUAGE DeriveAnyClass  #-}
{-# LANGUAGE OverloadedLists #-}

module Word where

import Control.Monad        (unless)
import Control.Monad.Random
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer
import Data.Aeson
import GHC.Generics

data Letter = Vowel | Consonant deriving stock (Eq, Show, Enum, Bounded)

data Letters = Letters {
    vowels     :: [String],
    consonants :: [String]
}

getLetters ∷ Letter → Letters → [String]
getLetters Vowel     = vowels
getLetters Consonant = consonants

instance FromJSON Letters where
    parseJSON (Array [v, c]) = Letters <$> parseJSON v <*> parseJSON c
    parseJSON x              = fail $ "Can't decode: " <> show x

data Location = Start | Middle | End

data Phonemes = Phonemes {
    start  :: Letters,
    middle :: Letters,
    end    :: Letters
}
    deriving stock (Generic)
    deriving anyclass (FromJSON)

-- should we be using smart maps here
-- or just mapping by function??? because functions are values
getByLoc ∷ Location → Phonemes → Letters
getByLoc Start  = start
getByLoc Middle = middle
getByLoc End    = end

switch ∷ Letter → Letter
switch Vowel     = Consonant
switch Consonant = Vowel

-- pick :: MonadRandom m => m Letter
-- pick = uniform

mkWord ∷ (MonadRandom m, MonadReader Phonemes m) ⇒ m String
mkWord = do
    letter' <- ask
    pure <$> execWriter $ evalState letter' genWord


location ∷ Int → Int → Location
location maxLength loc
    | loc == 0 = Start
    | loc == maxLength - 1 = End
    | otherwise = Middle

genWord ∷ (MonadRandom m, MonadReader Phonemes m, MonadState Letter m, MonadWriter [String] m) ⇒ Int → Int → m ()
genWord length loc = do
    letter' <- get
    letters <- asks $ getLetters letter' . getByLoc (location length loc)
    nextLetter <- uniform letters
    tell [nextLetter]
    unless (loc == length - 1) $ do
        modify switch
        genWord length (loc + 1)

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
