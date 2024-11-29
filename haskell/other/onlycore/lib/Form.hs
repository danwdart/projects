{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}

module Form where

import Control.Monad (void)
import Data.Text   (Text)
import Data.Text   qualified as T
import Text.Parsec

data IsDropdown = NotDropdown | Dropdown  deriving stock (Enum, Show)
data IsMulti = NotMulti | Multi deriving stock (Enum, Show)

data FormOption = FormOption {
    formOptionValue :: Text, -- TODO definable
    formOptionLabel :: Text
} deriving stock (Show)

type FormOptions = [FormOption]

data FormElementType = FreeText -- Maybe FormAttributes -- TODO ResultTypeType eg Text
    | Number
    | Date
    | Time
    | Choose IsDropdown IsMulti FormOptions -- TODO default
    deriving stock (Show)

data FormElement = FormElement {
    formElementLabel :: Text,
    formElementType  :: FormElementType
} deriving stock (Show)

type FormElements = [FormElement]

data Form = Form {
    formTitle    :: Text,
    formElements :: FormElements
} deriving stock (Show)

elementTypeParser ∷ Parsec Text u FormElementType
elementTypeParser =
    (FreeText <$ string "(free text)") <|>
    (Number <$ string "(number)") <|>
    (Date <$ string "(date)") <|>
    (Time <$ string "(time)") <|>
    (FreeText <$ string "...")

elementParser ∷ Parsec Text u FormElement
elementParser = do
    label' <- T.pack <$> many1 (noneOf "\n(.")
    optional spaces
    elementType <- elementTypeParser
    optional newline
    pure $ FormElement label' elementType

formParser ∷ Parsec Text u Form
formParser = do
    formTitle' <- T.pack <$> many1 (noneOf "\n")
    void newline
    void newline
    els <- many1 (elementParser <* optional newline)
    pure $ Form formTitle' els
