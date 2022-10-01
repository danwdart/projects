-- https://www.youtube.com/watch?v=LJQgYBQFtSE
{-# OPTIONS_GHC -Wno-unused-imports #-}
module Main where

import Data.Number.CReal
import Math.ContinuedFraction
import Sequence.Fibonacci
import Sequence.Lucas

main :: IO ()
main = mapM_ (\(n, v) -> putStrLn $ n <> "\n" <> v <> "\n") [
    -- maybe slow
    ("Pi (CF)", take 1002 . cfString $ (pi :: CF)),
    -- really slow
    -- ("Lucas (Naive, CF)", take 1002 . cfString $ ((sqrt 5 + 1) / 2 :: CF)),
    ("Pi (CReal)", showCReal 1000 (pi :: CReal)),
    ("Lucas (Seq, Integer)", show $ seqL 1000),
    ("Lucas (Naive, Double)", show (naiveL 1000 :: Double)),
    ("Lucas (Naive, CReal)", showCReal 1000 (naiveL 1000 :: CReal)),
    ("Lucas (Binet, Double)", show (binetL 1000 :: Double)),
    ("Lucas (Binet, CReal)", showCReal 1000 (binetL 1000 :: CReal)),
    ("Fibonacci (Seq, Integer)", show $ seqF 1000),
    ("Fibonacci (Naive, Double)", show (naiveF 1000 :: Double)),
    ("Fibonacci (Naive, CReal)", showCReal 1000 (naiveF 1000 :: CReal)),
    ("Fibonacci (Binet, Double)", show (binetF 1000 :: Double)),
    ("Fibonacci (Binet, CReal)", showCReal 1000 (binetF 1000 :: CReal))
    ]