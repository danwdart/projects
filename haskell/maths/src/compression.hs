{-# OPTIONS_GHC -Wwarn #-}

module Main (main) where

import Data.List qualified as L

-- Burrows-Wheeler Transform

rotateLString ∷ String → String
rotateLString []     = []
rotateLString (c:cs) = cs <> [c]

genBWTTable ∷ String → [String]
genBWTTable s = L.sort . take (length s) $ iterate rotateLString s

toBWTed ∷ String → String
toBWTed = fmap last . genBWTTable

main ∷ IO ()
main = do
    fileContents <- readFile "COPYING_SHORT"
    putStrLn . toBWTed $ fileContents

-- Run-Length Encoding



-- Lempel-Zif Encoding

