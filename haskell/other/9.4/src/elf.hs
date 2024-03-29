{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Trustworthy       #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

import Data.ByteString qualified as BS
-- import Data.Function
import Data.Elf

main ∷ IO ()
main = BS.readFile "/bin/sh" >>= (print . elfMachine) . parseElf
