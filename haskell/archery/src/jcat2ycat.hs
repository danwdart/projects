{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wwarn -Wno-unsafe #-}

module Main where

import Control.Category
import Data.Aeson
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Function.Free.Abstract
import Data.Primitive.Prims
import Data.Yaml qualified as Y
import System.Executable
import Prelude hiding ((.), id)

-- | Compiles a category from YAML category file to a Haskell function source file.
main ∷ IO ()
main = readToWrite (\bs ->
    (pure . BSL.fromStrict . Y.encode :: FreeFunc Prims () () -> IO BSL.ByteString) =<<
    (throwDecode :: BSL.ByteString -> IO (FreeFunc Prims () ())) =<<
    pure bs
    )
