{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-type-defaults #-}

module Main (main) where

import Control.Monad (void)
import Data.Digits
import Data.Graph.DGraph
import Data.Graph.Types
import Data.Graph.Visualize

happify ∷ Integer → Integer → Integer → Integer
happify power base = sum . fmap (^ power) . digits base

happyPairs :: [(Integer, Integer)]
happyPairs = fmap (\x -> (x, happify 2 10 x)) [1..1000]

fromPairs :: [(Integer, Integer)] -> DGraph Integer ()
fromPairs = fromList . fmap (\(from, to) -> (from, [(to, ())]))

happyGraph :: DGraph Integer ()
happyGraph = fromPairs happyPairs

main :: IO ()
main = void $ plotDGraph happyGraph