{-# LANGUAGE NoImplicitPrelude #-}

import Relude
import Control.Monad.IO.Unlift

main :: MonadIO m => m ()
main = putStrLn "Hi"