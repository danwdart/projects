{-# OPTIONS_GHC -Wno-unused-imports -Wno-type-defaults -Wno-unused-top-binds -Wno-unused-matches #-}

import Data.Digits
import Data.List         (intercalate)
import Data.List.Iterate
import Debug.Trace

{-# ANN module "HLint: ignore" #-}

answers ∷ [[Int]]
answers = happyLoop <$> [1..100]

formatList ∷ [Int] → String
formatList = intercalate " => " . (show <$>)

main ∷ IO ()
main = mapM_ putStrLn $ formatList <$> answers

happify ∷ Int → Int → Int → Int
happify power base = sum . fmap (^ power) . digits base

happyLoop ∷ Int → [Int]
happyLoop = iterateUntil (\x ->
    x < 10 ||
    {- cube loops -}
    x == 55 ||
    x == 371 ||
    x == 153 ||
    x == 217 ||
    x == 370 ||
    x == 407 ||
    x == 919
    ) (happify 3 10)

-- $> :t until
