{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.Foldable
-- import Data.List qualified as L
import Data.Map      qualified as M
import Data.Set      qualified as S
import Data.Word

weirdSequence ∷ [Word8]
weirdSequence = take 20 $ iterate (+ 100) 100

maps ∷ Word8 → [(Word8, Word8)]
maps quotient = [(x, y) | x <- [1..maxBound] :: [Word8], y <- [1..maxBound], x * y * quotient == x] -- meaning y = 1/q

specificMaps ∷ Word8 → [(Word8, Word8)]
specificMaps quotient = [(quotient * x, y) | x <- [1..(maxBound `div` quotient)] :: [Word8], y <- [1..maxBound], quotient * x * y == x] -- meaning y = 1/q


-- could probably accum map but i'm lazy

accum ∷ (Ord a, Ord b) ⇒ [(a, b)] → M.Map a (S.Set b)
accum []          = M.empty
accum ((k, v):xs) = M.insertWith S.union k (S.singleton v) (accum xs)

summarise ∷ (Show k, Show v) ⇒  M.Map k (S.Set v) → M.Map k String
summarise = M.mapWithKey (\k v -> show k <> ": " <> show (S.size v) <> " (" <> show v <> ")")

speakOfIt ∷ IO ()
speakOfIt = traverse_ putStrLn . summarise . accum $ maps 5

speakOfThat ∷ IO ()
speakOfThat = traverse_ putStrLn . summarise . accum $ specificMaps 5

main ∷ IO ()
main = pure ()
