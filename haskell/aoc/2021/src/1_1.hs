module Main (main) where

fnPairs ∷ Ord a ⇒ (a → a → b) → [a] → [b]
fnPairs _ []          = []
fnPairs _ [_]         = []
fnPairs fn (x1:x2:xs) = fn x1 x2:fnPairs fn (x2:xs)

main ∷ IO ()
main = do
    string <- readFile "data/1"
    let strings = lines string
    let numbers = fmap read strings :: [Integer]
    let soln = length . filter id $ fnPairs (<) numbers
    print soln
