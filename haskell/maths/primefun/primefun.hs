import Data.Numbers.Primes

sumfact = [(n, sum $ primeFactors n) | n <- [1..1000]]

main :: IO ()
main = undefined