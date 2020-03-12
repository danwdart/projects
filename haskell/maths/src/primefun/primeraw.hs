main :: IO ()
main = return ()

primes :: [Integer]
primes = sieve [2..] where
    sieve (p:ps) = p : sieve [x | x <- ps, mod x p /= 0]

eitherSides :: [Bool]
eitherSides = map (==5) $ drop 2 $ map (`mod` 6) primes

pairs :: [a] -> [(a, a)]
pairs n = zip n (tail n)

primePairs :: [(Integer, Integer)]
primePairs = pairs primes

-- twin, cousin etc
diffs :: [Integer]
diffs = map (`div` 2) $ tail $ map (uncurry subtract) primePairs

aSemiprime :: Integer
aSemiprime = (primes !! 150) * (primes !! 422)

coprime :: Integer -> Integer -> Bool
coprime a b = 1 == gcd a b

totient :: Integer -> Integer
totient n = fromIntegral $ length $ filter (coprime n) [1..n]

is :: (Integer -> Bool) -> [Integer]
is = flip filter [1..]