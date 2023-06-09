{-# LANGUAGE Safe #-}

module Data.Tuple.Triple where

secondOfThree ∷ (a, b, c) → b
secondOfThree (_, b, _) = b
