{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.List qualified as L (sort)

{-
function saa(n) {
    var ns = Math.pow(n,2),
        sn = String(ns),
        l = sn.length,
        fb = Number(sn.substring(0,l/2)),
        lb = Number(sn.substring(l/2,l));
        pure n == fb + lb;
}
for (var i = 0; i < 10000000; i++) {
    if (saa(i)) console.log(i);
}
-}

-- import Data.List

-- splitIntoPieces n l =

{-
saa :: (Num n) => n -> Bool
saa n = n == sum piecesNums where
    squared = n ** 2
    stringSquared = show ns
    piecesStrings = splitIntoPieces 2 stringSquared
    piecesNums = map read piecesStrings :: [Int]

main :: IO ()
main = print $ filter saa [1..10000000]
-}

-- String with leading zeroes, reverse, int, add.

-- >>> revAdd 3285
kapIter :: Integer -> Integer
kapIter n = (read . reverse . L.sort . show $ n) - (read . L.sort . show $ n)

-- https://stackoverflow.com/questions/7442892/repeatedly-applying-a-function-until-the-result-is-stable
convergeSingle :: Eq a => (a -> a) -> a -> a
convergeSingle = until =<< ((==) =<<)
{-# WARNING convergeSingle "Partial function. Loops forever on some inputs." #-}

{-
    1. Make a list of things dealt with
    2. Make a list of things seen already
    3. If seen anything before, add it to matches
    4. If seen something twice, finish
-}
-- | Ugh, very complex. That's gonna be like... at least n^2
-- Maybe we can do it backwards... with a vector or something. Because finding from the beginning? Nah nah nah.
stable :: Eq a => [a] -> [a]
stable xs = reverse $ go xs [] [] where
    go :: Eq a => [a] -> [a] -> [a] -> [a]
    go [] _ _ = []
    go (x:xs') seenOnce seenTwice = case any (== x) seenTwice of
        False -> case any (== x) seenOnce of
            False -> go xs' (x : seenOnce) seenTwice
            True -> go xs' seenOnce (x : seenTwice)
        True -> seenTwice

kap :: Integer -> [Integer]
kap = stable . iterate kapIter

setAt :: k -> v -> [(k, v)] -> [(k, v)]
setAt = undefined

{-}
grouped :: [(a, b)] -> [(a, [b])]
grouped xs = go xs [] where
    go :: [(a, b)] -> [(a, [b])] -> [(a, [b])]
    go [] sofar = sofar
    go ((k, v):xs) sofar = case L.find ((== k) . fst) sofar of
        Nothing -> go xs (k, [v]):sofar
        Just (k, v) -> go xs (setAt k v:vs sofar)
-}

main ∷ IO ()
main = pure ()