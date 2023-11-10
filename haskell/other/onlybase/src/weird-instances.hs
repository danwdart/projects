{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Main (main) where

import MagicString ()

main ∷ IO ()
main = do
    "hi" "hey"
