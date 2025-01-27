{-# OPTIONS_GHC -Wno-x-partial #-}

module Main (main) where

-- import Control.Monad
import Data.Char
import Numeric
import System.Environment

main ∷ IO ()
main = print =<< r where
    r ∷ IO (Maybe Int)
    r = fffsi fma
    fff ∷ (a → b) → IO (Maybe a) → IO (Maybe b)
    fff = fmap fmap fmap
    fma = fmap (maybeIndex 0) getArgs
    fffsi = fff stringToInteger
    maybeIndex ∷ Int → [a] → Maybe a
    maybeIndex index xs = if null xs then Nothing else Just $ (case drop index xs of
       x : _ -> x
       []    -> error _)
    stringToInteger ∷ String → Int
    stringToInteger string = fst $ (case readHex $ concatMap ((`showHex` "") . ord) (filter (/= ' ') string) of
       x : _ -> x
       []    -> error _)
