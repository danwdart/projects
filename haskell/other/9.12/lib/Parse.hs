{-# LANGUAGE UnicodeSyntax      #-}

module Parse where

import Control.Monad.Error.Class
import Data.ByteString.Char8                (ByteString)
-- import Data.ByteString.Char8 qualified as BS
import Data.Functor.Contravariant
import Data.Functor.Contravariant.Decidable
import Data.Functor.Contravariant.Divisible
import Data.Functor.Identity

data ParseError = ParseError {
    errMsg            :: String,
    parsingInQuestion :: ByteString
} deriving stock (Show)

-- deriving anyclass Exception
newtype Parser m a = Parser {
    runParser :: ByteString → m (ByteString, a)
}

-- data Result a = Parsed a | Incomplete ByteString a | Failed ParseError ByteString

class Parse a where
    parseOrFail :: MonadFail m ⇒ ByteString → m a
    parseOrError :: ByteString → a
    parseOrThrowError :: MonadError ParseError m ⇒ ByteString → m a
    parseOrFailVia :: MonadFail m ⇒ Parser m a → ByteString → m a
    parseOrErrorVia :: Parser Identity a → ByteString → a
    parseOrThrowErrorVia :: MonadError ParseError m ⇒ Parser m a → ByteString → m a
