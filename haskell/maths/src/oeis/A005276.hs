import           Factor

process ∷ Integer → Integer
process = sum . properFactors

betrothedsUpTo ∷ Integer → [Integer]
betrothedsUpTo n = fmap fst . filter (uncurry (==)) $ (\x -> (x, process . process $ x)) <$> [1..n]

main ∷ IO ()
main = mapM_ print $ betrothedsUpTo 10000
