module Main where

import Data.List
import Data.Numbers.Primes

solutions :: [(Int, Int, Int, Int, Int, Int, Int, Int, Int)]
solutions = nonuples

-- 1420 n/i flips, no cycles
nonuples :: [(Int, Int, Int, Int, Int, Int, Int, Int, Int)]
nonuples = map (\((a, b, c, d, e), (f, g, h, i, j)) -> (a, b, c, d, f, g, h, i, j)) $
    filter (\((a, b, c, d, e), (f, g, h, i, j)) ->
        isPrime(e + g) &&
        e == f &&
        d /= g &&
        c /= h &&
        b /= i &&
        a /= j
        ) $
    (,) <$> quintuples <*> quintuples

quintuples :: [(Int, Int, Int, Int, Int)]
quintuples = map (\((a, b, c), (d, e, f)) -> (a, b, d, e, f)) $
    filter (\((a, b, c), (d, e, f)) -> isPrime (c + e) && c == d && b /= e && a /= f) $
    (,) <$> triples <*> triples

triples :: [(Int, Int, Int)]
triples = map (\((a, b), (c, d)) -> (a, b, d)) $
    filter (\((a, b), (c, d)) -> isPrime (b + d) && b == c && a /= d) $
    (,) <$> pairs <*> pairs

pairs :: [(Int, Int)]
pairs = filter (isPrime . uncurry (+)) .
    filter (uncurry (/=)) $
    (,) <$> [1..9] <*> [1..9]

main :: IO ()
main = return ()