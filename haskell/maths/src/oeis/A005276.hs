module Main (main) where

import Data.Foldable
import Factor

betrothedsUpTo ∷ Integer → [Integer]
betrothedsUpTo n = fmap fst . filter (uncurry (==)) $ (\x -> (x, pred . aliquot . pred . aliquot $ x)) <$> [1..n]

main ∷ IO ()
main = traverse_ print $ betrothedsUpTo 10000
