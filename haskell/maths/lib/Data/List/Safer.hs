{-# OPTIONS_GHC -Wno-x-partial #-}

module Data.List.Safer where

initOrEmpty ∷ [a] → [a]
initOrEmpty [] = []
initOrEmpty xs = init xs
