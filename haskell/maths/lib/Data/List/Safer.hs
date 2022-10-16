module Data.List.Safer where

tailOrEmpty ∷ [a] → [a]
tailOrEmpty [] = []
tailOrEmpty xs = tail xs

initOrEmpty ∷ [a] → [a]
initOrEmpty [] = []
initOrEmpty xs = init xs
