module Main (main) where

import Data.Digits
-- import Data.Numbers.Primes
import Factor

{-# ANN module "HLint: ignore Avoid restricted function" #-}

-- >>> take 10 highlyComposite

-- >>> 2 `divides` 3

-- >>> 24 `divides` 3

-- >>> length . factors $ 24

-- >>> take 10 highlyComposite
highlyComposite ∷ [Integer]
highlyComposite = go 0 1 where
    go ∷ Int → Integer → [Integer]
    go record n
        | length (factors n) > record = n : go (length . factors $ n) (n + 1)
        | otherwise = go record (n + 1)

main ∷ IO ()
main = mapM_ print $ read @Integer . concatMap show . digits 2 <$> take 16 highlyComposite
