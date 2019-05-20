import Data.Numbers.Primes

sumfact :: [(Integer, Integer)]
sumfact = [(n, sum $ primeFactors n) | n <- [1..1000]]

countfact :: [(Integer, Integer)]
countfact = [(n, length $ primeFactors n) | n <- [1..1000]]


main :: IO ()
main = undefined
