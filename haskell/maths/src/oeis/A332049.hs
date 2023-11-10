
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import NumList

-- Mine, 2019-11-17
-- Also A332049
sumList ∷ [Int]
sumList = sum . toNumList <$> [2..200]

main ∷ IO ()
main = print sumList
