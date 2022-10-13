module Main where

import Data.Numbers.Primes
import Data.Ratio

harmonic :: Integer -> Rational
harmonic x = sum $ recip . fromIntegral <$> [1..x]

harmonics :: [Rational]
harmonics = harmonic <$> [1..]

harmonicDenoms :: [Integer]
harmonicDenoms = denominator <$> harmonics

harmonicDenomPrimeFactors :: [[Integer]]
harmonicDenomPrimeFactors = primeFactors <$> harmonicDenoms

oeisA349049 :: [Int]
oeisA349049 = length <$> harmonicDenomPrimeFactors

sumFactHarmonicDenom :: [Integer]
sumFactHarmonicDenom = sum <$> harmonicDenomPrimeFactors

main :: IO ()
main = print @[Integer] $ floor . log . log @Double . fromInteger <$> sumFactHarmonicDenom