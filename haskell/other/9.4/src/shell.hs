{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

import Data.Conduit.Shell

main ∷ IO ()
main = run $ do
    ls ["-lah"]
