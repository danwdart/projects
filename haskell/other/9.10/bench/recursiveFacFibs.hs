

module Main (main) where

import Criterion.Main
import Data.Array     qualified as A
import Data.Dynamic
import Data.Foldable
import Data.Maybe
import Data.Vector    qualified as V

facsNaive ∷ [Integer]
facsNaive = undefined

facNaive ∷ Integer → Integer
facNaive 0 = 1
facNaive 1 = 1
facNaive x = x * facNaive (x - 1)

facsTailRecursive ∷ [Integer]
facsTailRecursive = undefined

facTailRecursive ∷ Integer → Integer
facTailRecursive x = go x 1 where
    go ∷ Integer → Integer → Integer
    go 1 acc = acc
    go x acc = go (x - 1) (x * acc)

fibsNaive ∷ [Integer]
fibsNaive = undefined

fibNaive ∷ Integer → Integer
fibNaive 0 = 0
fibNaive 1 = 1
fibNaive x = fibNaive (x - 1) + fibNaive (x - 2)

fibsTailRecursive ∷ [Integer]
fibsTailRecursive = undefined

fibTailRecursive ∷ Integer → Integer
fibTailRecursive = undefined -- todo tuple swapping and stuff

main = defaultMain [
    bgroup "fac" [
        {-bgroup "list" [
            bench "naive" $ nf (facsNaive !!) 100,
            bench "tail recursive" $ nf (facsTailRecursive !!) 100
            ],-}
        bgroup "direct" [
            bench "naive" $ nf facNaive 100,
            bench "tail recursive" $ nf facTailRecursive 100
            ]
        ]{-,
    bgroup "fib" [
        bgroup "list" [
            bench "naive" $ nf (fibsNaive !!) 100,
            bench "tail recursive" $ nf (fibsTailRecursive !!) 100
            ],
        bgroup "direct" [
            bench "naive" $ nf fibsNaive 100,
            bench "tail recursive" $ nf fibsTailRecursive 100
            ]
        ]-}
    ]
