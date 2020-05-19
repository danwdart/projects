{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Control.Monad
import           System.Random

main ∷ IO ()
main = print =<< avg <$> replicateM 1000000 (randomJump 1 10)

randomJump ∷ Int → Int → IO Int
randomJump js total = do
    a <- randomRIO (1, total) :: IO Int
    if a < total
    then randomJump (js + 1) (total - a)
    else return js

freqList ∷ [Int] → [(Int, Int)]
freqList = undefined

avg ∷ [Int] → Double
avg xs = fromIntegral (sum xs) / fromIntegral (length xs)
