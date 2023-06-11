{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wwarn -Wno-unsafe #-}

module Main where

import Control.Category
import Control.Category.Interpret
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Code.PHP.Lamb
import Data.Function.Free.Abstract
import Data.Primitive.Prims
import Data.Render
import Data.Yaml qualified as Y
import System.Executable
import Prelude hiding ((.), id)

-- | Compiles a category from YAML category file to a Haskell function source file.
main ∷ IO ()
main = readToWrite (\bs ->
    (pure . render :: PHPLamb () () -> IO BSL.ByteString) =<<
    (pure . interpret :: FreeFunc Prims () () -> IO (PHPLamb () ())) =<<
    (Y.decodeThrow . BSL.toStrict :: BSL.ByteString -> IO (FreeFunc Prims () ())) =<<
    pure bs
    )
