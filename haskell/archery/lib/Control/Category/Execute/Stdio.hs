{-# LANGUAGE Safe #-}

module Control.Category.Execute.Stdio where

import Control.Monad.IO.Class

class ExecuteStdio cat where
    executeViaStdio :: (MonadIO m) => cat String String -> String -> m String
