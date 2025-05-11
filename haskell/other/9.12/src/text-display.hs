{-# LANGUAGE DerivingVia       #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Trustworthy       #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-imports #-}

module Main (main) where

-- https://hackage.haskell.org/package/text-display-0.0.3.0/docs/Data-Text-Display.html

import Data.Text              (Text)
import Data.Text              qualified as T
import Data.Text.Display
import Data.Text.IO           as TIO
import Data.Text.Lazy.Builder

newtype K = K Int -- { _s :: Int }

newtype S = S Text
    deriving stock Show
    deriving Display via (ShowInstance S)

newtype P = P Text
    deriving Display via (OpaqueInstance "redacted" P)

instance Display K where
    displayBuilder = undefined -- T.show . s


main ∷ IO ()
main = do
    TIO.putStrLn . display $ K 1
    TIO.putStrLn . display $ S "heh"
    TIO.putStrLn . display $ P "aaa"
