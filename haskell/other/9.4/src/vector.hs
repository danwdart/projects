{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-imports #-}

module Main (main) where

import Data.Vector

a ∷ Vector Int
a = [0, 0, 0, 0]

main ∷ IO ()
main = print a
