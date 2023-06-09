{-# LANGUAGE Safe #-}

module Control.Category.Execute.Stdio where

import Control.Monad.IO.Class

class ExecuteStdio cat where
    executeViaStdio :: (Show input, Read output, MonadIO m) => cat () () -> input -> m output