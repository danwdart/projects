{-# LANGUAGE UnicodeSyntax      #-}

module Format where

import Control.Monad.Error.Class
import Data.ByteString.Char8                (ByteString)
-- import Data.ByteString.Char8 qualified as BS
import Data.Functor.Contravariant
import Data.Functor.Contravariant.Decidable
import Data.Functor.Contravariant.Divisible
import Data.Functor.Identity

newtype Formatter a = Formatter {
    getFormatter :: a → ByteString
}

instance Contravariant Formatter where
    contramap f (Formatter g) = Formatter (g . f)

instance Divisible Formatter where

class Format a where
    format :: a → ByteString
    formatVia :: Formatter a → a → ByteString
