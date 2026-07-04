{-# OPTIONS_GHC -Wwarn #-}

module Main (main) where

import Data.Map qualified as M
import Data.Maybe (fromMaybe)
import Numeric.Words

genFromGuess :: Int -> String
genFromGuess n = "This sentence has " <> fromMaybe "" (M.lookup (fromIntegral n) defWords) <> " characters."

countType :: (a -> Bool) -> [a] -> Int
countType f xs = length $ filter f xs

main :: IO ()
main = putStrLn $ genFromGuess 22