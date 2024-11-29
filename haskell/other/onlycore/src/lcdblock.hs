module Main (main) where

import Data.Foldable
import LCDBlock

main ∷ IO ()
main = traverse_ printN ([1..127] :: [Int])
