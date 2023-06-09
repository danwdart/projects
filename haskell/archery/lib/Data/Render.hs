{-# LANGUAGE Safe #-}

module Data.Render where

import Data.ByteString.Lazy.Char8 qualified as BSL

class Render a where
    render :: a → BSL.ByteString
