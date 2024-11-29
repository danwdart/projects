{-# LANGUAGE PackageImports #-}

module Main (main) where

import "mtl" Control.Monad.Writer
import Data.Foldable

type MyWriter = Writer [String] Int

logArith ∷ Int → MyWriter
logArith x = writer (x, ["x is " <> show x])

logArith2 ∷ Int → MyWriter
logArith2 x = writer (x + 2, ["x is now " <> show (x + 2)])

withFns ∷ MyWriter
withFns = logArith 1 >>= logArith2

withDo ∷ MyWriter
withDo = do
    x <- logArith 1
    tell ["Hmm..."]
    logArith2 x

newExample ∷ Writer [String] String
newExample = do
    tell ["One"]
    tell ["Two"]
    pure "Three!"

main ∷ IO ()
main = do
    traverse_ print [
        runWriter withFns,
        runWriter withDo
        ]
    print $ runWriter newExample
