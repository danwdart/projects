{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wwarn -Wno-unsafe #-}

module Main where

import Control.Arrow (Kleisli(..))
import Control.Category
import Control.Category.Interpret
import Data.Aeson
import Data.ByteString.Lazy.Char8 qualified as BSL
import Data.Maybe
import Data.Function.Free.Abstract
import Data.Primitive.Prims
import System.Executable
import Prelude hiding ((.), id)

-- | Compiles a category from YAML category file to a Haskell function source file.
main ∷ IO ()
main = readToOp (\bs ->
        flip runKleisli () =<<
        (pure . interpret :: FreeFunc Prims () () -> IO (Kleisli IO () ())) =<<
        (throwDecode  :: BSL.ByteString -> IO (FreeFunc Prims () ())) =<<
        pure bs
        )
