import Data.Numbers.Primes

squaredseq :: [Integer]
squaredseq = (`div` 24) . pred . (\x -> x * x) <$> (primes :: [Integer])

main :: IO ()
main = print $ take 100 squaredseq