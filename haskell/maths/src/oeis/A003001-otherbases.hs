{-# OPTIONS_GHC -Wno-unused-imports -Wno-type-defaults -Wno-unused-top-binds -Wno-unused-matches #-}

import Data.Digits
-- import           Data.List
import Data.List.Nub
import Data.List.Repeat

{-# ANN module "HLint: ignore" #-}

largest ∷ Integer
largest = 1000000

main ∷ IO ()
main = do
    -- 2
    -- mapM_ print $ recordsInBase 2 largest
    -- 3, 8, 26 = 3^3 - 1
    -- mapM_ print $ recordsInBase 3 largest
    -- 4, 10, 63 = 4^3 - 1
    -- mapM_ print $ recordsInBase 4 largest
    -- 5, 13, 68, 2344
    -- mapM_ print $ recordsInBase 5 largest
    -- 6, 15, 23, 172, 3629
    -- mapM_ print $ recordsInBase 6 largest
    -- 7, 18, 27, 131, 1601, 11262, 686285
    -- mapM_ print $ recordsInBase 7 largest
    -- 8, 20, 31, 174, 1535, 57596799??
    -- mapM_ print $ recordsInBase 8 largest
    -- 9, 23, 35, 52, 394, 30536, 1409794??
    -- mapM_ print $ recordsInBase 9 largest
    -- A003001: 10, 25, 39, 77, 679, 6788, 68889...
    mapM_ print $ recordsInBase 10 largest
    -- 11, 28, 43, 75, 317, 4684, 38200, 757074
    -- 1: n + 1
    -- 2: numbers congruent to 0, 3 mod 5
    -- 3: A064867
    -- 4: A064868
    -- 5: A064869
    -- 6: A064870
    -- 7: A064871
    -- 8: A064872
    -- mapM_ print $ recordsInBase 11 largest
    -- 132161
    -- mapM_ print $ recordsInBase 20 100000

findViableUpToInBase ∷ Integer → Integer → [Integer]
findViableUpToInBase base n = [0..n]

recordsInBase ∷ Integer → Integer → [(Integer, Int)]
recordsInBase base n = tail $ nubOn snd $ ((,) <$> id <*> pers base) <$> findViableUpToInBase base n

step ∷ Integer → Integer → Integer
step base = product . digits base

takeUntilCond ∷ (a → Bool) → [a] → [a]
takeUntilCond _ [] = []
takeUntilCond f (x:xs)
    | f x = [x]
    | otherwise = x:takeUntilCond f xs

pers ∷ Integer → Integer → Int
pers base = pred . length . takeUntilCond (< base) . iterate (step base)
