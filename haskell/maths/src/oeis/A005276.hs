module Main (main) where

import Factor

betrothedsUpTo ∷ Integer → [Integer]
betrothedsUpTo n = fmap fst . filter (uncurry (==)) $ (\x -> (x, pred . aliquot . pred . aliquot $ x)) <$> [1..n]

main ∷ IO ()
main = mapM_ print $ betrothedsUpTo 10000
