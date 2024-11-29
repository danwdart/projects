-- Faro interlacing

{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.Foldable
import Data.List (transpose)

elems ∷ [Int]
elems = [0..51]

interlace ∷ [a] → [a] → [a]
interlace d1 d2 = concat . transpose $ [d1, d2]

faroOut ∷ [a] → [a]
faroOut = uncurry interlace . splitAt 26

faroIn ∷ [a] → [a]
faroIn = uncurry (flip interlace) . splitAt 26

untilTimes ∷ forall a. Int → (a → Bool) → (a → a) → a → Maybe Int
untilTimes maxTimes check iterator = go 0 where
    go ∷ Int → a → Maybe Int
    go iterNum element
        | check element = Just iterNum
        | maxTimes <= iterNum = Nothing
        | otherwise = go (iterNum + 1) (iterator element)

untilTimesAtLeastOne ∷ forall a. Int → (a → Bool) → (a → a) → a → Maybe Int
untilTimesAtLeastOne maxTimes check iterator = go 0 where
    go ∷ Int → a → Maybe Int
    go iterNum element
        | iterNum > 0 && check element = Just iterNum
        | maxTimes <= iterNum = Nothing
        | otherwise = go (iterNum + 1) (iterator element)

calculateWith ∷ ([Int] → [Int]) → Maybe Int
calculateWith fn = untilTimesAtLeastOne 100000 (== elems) fn elems

main ∷ IO ()
main = traverse_ (\(name, calculation) -> putStrLn $ name <> ": " <> show (calculateWith calculation)) [
    ("Out", faroOut),
    ("In", faroIn),
    ("In Out", faroOut . faroIn),
    ("Out In", faroIn . faroOut),
    ("In Out In", faroIn . faroOut . faroIn),
    ("In Out Out", faroOut . faroOut . faroIn),
    ("Out In In", faroIn . faroIn . faroOut),
    ("Out In Out", faroOut . faroIn . faroOut),
    ("In Out Out In", faroIn . faroOut . faroOut . faroIn),
    ("In In Out In", faroIn . faroOut . faroIn . faroIn),
    ("Out Out Out Out In", faroIn . faroOut . faroOut . faroOut . faroOut)
    ]
