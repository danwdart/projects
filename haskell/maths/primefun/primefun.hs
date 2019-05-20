import Data.Function
import Data.List
import Data.Numbers.Primes

sumfact :: [(Integer, Integer)]
sumfact = [(n, sum $ primeFactors n) | n <- [1..1000]]

countfact :: [(Integer, Int)]
countfact = [(n, length $ primeFactors n) | n <- [1..1000]]

-- nubBy (on (==) snd) countfact

main :: IO ()
main = undefined
