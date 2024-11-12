{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import Data.Bifunctor
import Data.Ratio

-- todo: lib this

-- we could've done that with chooses and facts but this is cooler maybe
pascal ∷ [[Integer]]
pascal = iterate nextRow [1]

nextRow ∷ Num a ⇒ [a] → [a]
nextRow xs = zipWith (+) ((0:xs) <> [0]) (xs <> [0])

-- hahahahaaa this is awful why would you do this?
-- because factorialising a HUGE number couldn't be done a better way?
-- yes it could it totally could
chooseRestrictedByMaxListSize ∷ Integer → Integer → Integer
chooseRestrictedByMaxListSize a b = pascal !! fromIntegral a !! fromIntegral b

stripOutside ∷ [a] → [a]
stripOutside = drop 1 . reverse . drop 1 . reverse

weird ∷ Fractional a ⇒ [[a]]
weird = stripOutside <$> zipWith (\n xs -> (/ fromIntegral n) <$> xs) ([0..] :: [Integer]) (stripOutside <$> fmap (fmap fromIntegral) pascal)

-- this is https://oeis.org/A215563 so maybe we should make the project
onlythePrimeInts ∷ [[Integer]]
onlythePrimeInts = fmap round <$> filter (all ((== 1) . denominator)) (weird :: [[Rational]])

onlyThePrimes ∷ [Integer]
onlyThePrimes = fmap fst . filter (all ((== 1) . denominator) . snd) $ zip [0 .. ] (weird :: [[Rational]])

primesWithInts ∷ [(Integer, [Integer])]
primesWithInts = fmap (second . fmap $ round) . filter (all ((== 1) . denominator) . snd) $ zip [0 .. ] (weird :: [[Rational]])

main ∷ IO ()
main = pure ()
