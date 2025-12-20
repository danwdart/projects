{-# OPTIONS_GHC -Wno-unsafe #-}
-- why is it unused? it's not unused wtf
{-# LANGUAGE DerivingVia           #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskellQuotes #-}
{-# LANGUAGE Unsafe                #-}

module Schema where

{- Provide a dynamic schema. -}

-- import Data.Map
-- import Data.Text                  qualified as T
import Data.Text                  (Text)
import Data.Yaml                  hiding (decodeFile)
-- import Data.Yaml.Parser
import GHC.Generics
import Language.Haskell.TH
import Language.Haskell.TH.Syntax

newtype ColumnType = ColumnType Name
    deriving stock (Eq, Show, Generic)

instance FromJSON ColumnType where
    parseJSON (String s)
        | s == "Text" = pure $ ColumnType ''Text
        | s == "Maybe Text" = pure $ ColumnType ''Text
        | s == "Maybe Int" = pure $ ColumnType ''Int
        | otherwise = fail "Invalid type; expected Text | Maybe Text | Int"
    parseJSON _ = fail "Invalid type; expected String"

instance ToJSON ColumnType where
    toJSON (ColumnType n) = toJSON (show n)

instance Lift ColumnType where
    lift c = lift (show c)
    liftTyped _ = Code undefined -- liftTyped c

data Field = Field {
    columnName :: Text,
    columnType :: ColumnType
} deriving stock (Eq, Show, Generic, Lift)
    deriving (FromJSON, ToJSON) via Generically Field

newtype Schema = Schema [(Text, Field)]
    deriving stock (Eq, Show, Generic, Lift)
    deriving (FromJSON, ToJSON) via Generically Schema

expToDecsQ ∷ TExp Schema → DecsQ
expToDecsQ _ = [d|
    data Book = Book {
        title :: Text,
        author :: Text,
        isbn :: Text
    } deriving stock (Show, Eq, Generic, Lift)
        deriving anyclass (FromJSON, ToJSON)
    |]
