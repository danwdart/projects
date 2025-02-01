{-# OPTIONS_GHC -Wno-unsafe #-}
-- why is it unused? it's not unused wtf
{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DerivingVia           #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskellQuotes #-}
{-# LANGUAGE Unsafe                #-}

module Schema where

{- Provide a dynamic schema. -}

-- import Data.Map
import Data.Text
import Data.Yaml                  hiding (decodeFile)
import Data.Yaml.Parser
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
        | otherwise = typeMismatch "Text | Maybe Text | Int" s
    parseJSON invalid = typeMismatch "String" invalid

instance ToJSON ColumnType where
    toJSON (ColumnType n) = toJSON (show n)

instance Lift ColumnType where
    lift c = lift (show c)
    liftTyped c = Code $ liftTyped c

data Field = Field {
    columnName :: Text,
    columnType :: ColumnType
} deriving (Eq, Show, Generic, FromJSON, ToJSON, Lift)

newtype Schema = Schema [(Text, Field)]
    deriving (Eq, Show, Generic, FromJSON, ToJSON, Lift)

expToDecsQ ∷ TExp Schema → DecsQ
expToDecsQ _ = [d|
    data Book = Book {
        title :: Text,
        author :: Text,
        isbn :: Text
    } deriving (Show, Eq, Generic, FromJSON, ToJSON, Lift)
    |]
