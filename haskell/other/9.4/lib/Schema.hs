{-# OPTIONS_GHC -Wno-unsafe #-}
{-# LANGUAGE Unsafe, DeriveAnyClass, DeriveGeneric, DerivingVia, OverloadedStrings #-}

module Schema where

{- Provide a dynamic schema. -}

-- import Data.Map
import Data.Text
import Data.Yaml hiding (decodeFile)
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
        | otherwise = error $ "Nah, that's no good: " <> unpack s
    parseJSON _ = error "not string"

instance ToJSON ColumnType where
    toJSON (ColumnType n) = toJSON (show n)

instance Lift ColumnType where
    lift c = lift (show c)
    liftTyped _ = undefined -- Code $ liftTyped c


data Field = Field {
    columnName :: Text,
    columnType :: ColumnType
} deriving (Eq, Show, Generic, FromJSON, ToJSON, Lift)

newtype Schema = Schema [(Text, Field)]
    deriving (Eq, Show, Generic, FromJSON, ToJSON, Lift)

expToDecsQ :: TExp Schema -> DecsQ
expToDecsQ _ = [d|
        data Book = Book {
            title :: Text,
            author :: Text,
            isbn :: Text
        } deriving (Show, Eq, Generic, FromJSON, ToJSON, Lift)
    |]
