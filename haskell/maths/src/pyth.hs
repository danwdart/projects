module Main (main) where

import Data.Foldable

-- we get results when n is the sum of 2 squares
naiveRootNUpTo ∷ Integer → Integer → [(Integer, Integer, Integer)]
naiveRootNUpTo n maxNum = [
    (a, b, c) | a <- [1..maxNum], b <- [1..maxNum], c <- [1..maxNum], a ^ (2 :: Integer) + b ^ (2 :: Integer) == n * c ^ (2 :: Integer) && a < b
    ]

main ∷ IO ()
main = do
    traverse_ (\n ->
        {-traverse_ (\(a, b, c) ->
            putStrLn $ show a <> "² + " <> show b <> "² = " <> (if n == 1 then "" else show n <> "×") <> show c <> "²"
            ) $ -}
        print (n, length (naiveRootNUpTo n 100))
        ) [1..100]
