-- https://www.youtube.com/watch?v=LJQgYBQFtSE
{-# OPTIONS_GHC -Wno-unused-imports #-}
module Main where

import Data.Number.CReal
import Math.ContinuedFraction

main :: IO ()
main = do
    -- maybe slow idk
    let picf = pi :: CF
    putStrLn . take 1002 . cfString $ picf -- +2 for "3."

    -- maybe twice as fast idk
    let picr = pi :: CReal
    putStrLn . showCReal 1000 $ picr