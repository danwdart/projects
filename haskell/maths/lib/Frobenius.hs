{-# LANGUAGE UnicodeSyntax #-}

module Frobenius where

frob :: Int -> Int -> Maybe Int
frob a b = if 1 == gcd a b then Just (a * b - a - b) else Nothing