{-# OPTIONS_GHC -Wno-unused-matches -Wno-unused-top-binds #-}

module Main (main) where

-- import Data.Foldable

shl ∷ [a] → [a]
shl []     = []
shl (x:xs) = xs <> [x]

diffy ∷ [Int] → [Int]
diffy xs = zipWith (\x y -> abs (x - y)) xs (shl xs)

isAllZeros ∷ [Int] → Bool
isAllZeros = all (== 0)

allEqual ∷ (Eq a) ⇒ [a] → Bool
allEqual []     = True
allEqual (x:xs) = all (== x) xs

iterUntil ∷ (Eq a) ⇒ (a → Bool) → (a → a) → a → a
iterUntil pred' f x = if pred' x then x else iterUntil pred' f (f x)

iterCount ∷ (Eq a) ⇒ (a → Bool) → (a → a) → a → Int
iterCount pred' f x = if pred' x then 0 else 1 + iterCount pred' f (f x)

diffCount ∷ [Int] → Int
diffCount = iterCount isAllZeros diffy

soln ∷ Int → [([Int], Int)]
soln max' = [
    ([a,b,c,d], diffCount [a,b,c,d]) |
        a<-[1..max'],
        b<-[1..max'],
        c<-[1..max'],
        d<-[1..max'],
        diffCount [a,b,c,d] == 10 -- 50 = 13?
        -- Not the most efficient loop
    ]

main ∷ IO ()
main = do
    print $ diffCount [1,2,3,4::Int]
    print $ diffCount [112211,2,3,4000::Int]
    -- traverse_ print $ soln 50
    print . length $ soln 25
