module Main where

import Data.Foldable
import Data.List qualified as L

-- we can be cleverer later
-- todo nonempty
diffsum :: [Int] -> ([Int], Int)
diffsum [] = ([], 0)
-- diffsum xs = sum $ zipWith (\a b -> abs (b - a)) xs (tail xs)
diffsum alls@[a, b, c, d, e, f, g, h, i, j] = (alls,
    abs (b - a) + abs (c - b) + abs (d - c) + abs(e - d) + abs(f - e) +
    abs (g - f) + abs (h - g) + abs (i - h) + abs(j - i)
    )
diffsum _ = undefined

-- TODO include the rest of the best
best :: (Eq b, Num b, Foldable f) => (b -> b -> b) -> (a -> b) -> f a -> (Int, b, [a]) -- ([a], b)
best cmp f = foldr' (\x (count, bestb, besta) -> if bestb == cmp bestb (f x) then (1 + count, bestb, besta <> [x]) else (1, f x, [x])) (0, 0, mempty)

-- huh why is... oh
bestDS :: [[Int]] -> (Int, Int, [[Int]])
bestDS = best max (snd . diffsum)

main :: IO ()
main = print $ bestDS (L.permutations [0,1,2,3,4,5,6,7,8,9])