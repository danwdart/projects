{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-type-defaults #-}

module Main (main) where

import Currency
-- instance Num

pound ∷ Money
pound = Money 1 gbp

main ∷ IO ()
main = print pound
