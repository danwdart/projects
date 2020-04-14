{-# LANGUAGE NoImplicitPrelude #-}

module Lib.Prelude where

import qualified Prelude as P
import Prelude ((.), read, show, Show)
import Control.Monad.IO.Class
import Data.String

toString :: (IsString s, Show s) => s -> String
toString = read . show

putStrLn :: (MonadIO m, IsString s, Show s) => s -> m ()
putStrLn = liftIO . P.putStrLn . toString

print :: (MonadIO m, Show s) => s -> m ()
print = liftIO . P.print

