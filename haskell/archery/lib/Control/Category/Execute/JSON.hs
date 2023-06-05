{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Control.Category.Execute.JSON where

import Control.Monad.IO.Class
import Data.Aeson

class ExecuteJSON cat where
    executeViaJSON :: (ToJSON input, FromJSON output, MonadIO m) => cat input output -> input -> m (Maybe output)