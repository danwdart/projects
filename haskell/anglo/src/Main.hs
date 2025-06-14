{-# LANGUAGE DerivingVia  #-}
{-# LANGUAGE OverloadedLists #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Main (main) where

import Data.Aeson
import Data.Aeson.Types
import Data.ByteString.Char8 (ByteString)
-- import Data.ByteString.Char8 qualified as BS
import Data.Text.Encoding
import GHC.Generics

data WordsVC = WordsVC {
    vowels     :: [ByteString],
    consonants :: [ByteString]
} deriving stock (Show)

instance FromJSON ByteString where
    parseJSON (String a) = pure (encodeUtf8 a)
    parseJSON a = typeMismatch "String" a

instance FromJSON WordsVC where
    parseJSON (Array [vs, cs]) = WordsVC <$> parseJSON vs <*> parseJSON cs
    parseJSON other = typeMismatch "Array" other

data WordData = WordData {
    start  :: WordsVC,
    middle :: WordsVC,
    end    :: WordsVC
} deriving stock (Show, Generic)
    deriving (FromJSON) via Generically WordData

main ∷ IO ()
main = do
    worddata <- decodeFileStrict' "lang/en_GB.json" :: IO (Maybe WordData)
    print worddata
