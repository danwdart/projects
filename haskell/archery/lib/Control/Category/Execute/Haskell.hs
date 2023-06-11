{-# LANGUAGE Safe #-}

module Control.Category.Execute.Haskell where

import Control.Monad.IO.Class
import Prelude                hiding (id, (.))

class ExecuteHaskell cat where
    executeViaGHCi :: (Show input, Read output, MonadIO m) ⇒ cat input output → input → m output
