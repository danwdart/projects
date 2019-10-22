module Funk.Round (roundNumbers) where

import Data.List (sort)

roundDecimal :: [Integer]
roundDecimal = (*) <$> [10 ^ n | n <- [0..10] :: [Int]] <*> [1..9]

roundBinary :: [Integer]
roundBinary = (*) <$> [2 ^ n | n <- [1..30] :: [Int]] <*> [1]

roundNumbers :: [Integer]
roundNumbers = sort $ roundDecimal <> roundBinary
