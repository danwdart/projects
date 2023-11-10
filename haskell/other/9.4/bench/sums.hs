

module Main (main) where

import Criterion.Main
import Data.Array     qualified as A
import Data.Dynamic
import Data.Foldable
import Data.Maybe
import Data.Vector    qualified as V

elements ∷ Int
elements = 1000000

-- TODO ensure that this gets fully evaluated before timing
listRepl ∷ a → [a]
listRepl = replicate elements

list ∷ [Int]
list = listRepl (1 :: Int)

vecRepl ∷ a → V.Vector a
vecRepl = V.replicate elements

arrRepl ∷ a → A.Array Int Int
arrRepl n = A.listArray (0, elements - 1) [0..elements - 1]


main = defaultMain [
    bgroup "sums" [
        bench "get list" $ nf id list,
        bench "sum" $ nf sum list,
        bench "foldl" $ nf sum list,
        bench "foldl'" $ nf (foldl' (+) 0) list,
        bench "foldr" $ nf sum list,
        bench "foldr'" $ nf (foldr' (+) 0) list
        ]
    ]
