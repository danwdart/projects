{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wwarn -Wno-unsafe #-}

module Main where

import Control.Category
import Control.Category.Interpret
import Data.Aeson
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Code.Haskell.Lamb
import Data.Function.Free.Abstract
import Data.Primitive.Prims
import Data.Render
import System.Executable
import Prelude hiding ((.), id)

-- | Compiles a category from YAML category file to a Haskell function source file.
main ∷ IO ()
main = readToWrite (\bs ->
    (pure . render :: HSLamb () () -> IO BSL.ByteString) =<<
    (pure . interpret :: FreeFunc Prims () () -> IO (HSLamb () ())) =<<
    (throwDecode  :: BSL.ByteString -> IO (FreeFunc Prims () ())) =<<
    pure bs
    )
