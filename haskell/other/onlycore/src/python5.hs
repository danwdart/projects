{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

module Main (main) where

import BubbleSort

main ∷ IO ()
main = print $ bubbleSort [1,6,2,6,4,2]
