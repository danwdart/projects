module Main (main) where

import Data.List (elemIndex)

main ∷ IO ()
main = print $ iterate iter [0] !! 151

iter ∷ [Integer] → [Integer]
iter [] = [0]
iter xs = let (most, end) = (init xs, last xs)
    in (most <> [end]) <> [maybe 0 (\x -> fromIntegral $ x + 1) (end `elemIndex` reverse most)]
