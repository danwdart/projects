{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module BubbleSort (bubbleSort) where

import Control.Monad
import Control.Monad.ST
import Data.Array.ST
import Data.Foldable

bubbleSortST ∷ STArray s Int Int → ST s ()
bubbleSortST xs = do
    (low, high) <- getBounds xs
    for_ [low .. high - 1] $ \i ->
        for_ [i + 1 .. high] $ \j -> do
            x <- readArray xs i
            y <- readArray xs j
            when (x > y) $ do
                writeArray xs i y
                writeArray xs j x

bubbleSort ∷ [Int] → [Int]
bubbleSort xs = runST $ do
    a <- newListArray (0, length xs - 1) xs
    bubbleSortST a
    getElems a
