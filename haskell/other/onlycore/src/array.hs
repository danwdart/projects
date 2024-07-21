{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-safe -Wno-unsafe #-}

module Main (main) where

import Data.Array.IO

type IA = IOArray Int Int

mkArr ∷ IO IA
mkArr = newArray_ (0, 1)

wrArr ∷ IA → IO ()
wrArr a = do
    writeArray a 0 1
    writeArray a 1 2

arrToInt ∷ IA → IO [Int]
arrToInt = getElems

main ∷ IO ()
main = do
    a <- mkArr
    wrArr a
    c <- arrToInt a
    print c
