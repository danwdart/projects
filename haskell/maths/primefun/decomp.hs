import Data.Numbers.Primes

bintodec :: [Int] -> Int
bintodec = sum . zipWith (*) (iterate (*2) 1) . reverse

decomp :: (Integer, [Integer]) -> (Integer, [Integer])
decomp (x, ys) = if even x then (x `div` 2, 0:ys) else (x - 1, 1:ys)

decompOther :: (Integer, [Integer]) -> (Integer, [Integer])
decompOther (x, ys) = if odd x then (x `div` 2, 0:ys) else (x - 1, 1:ys)

zeck :: Integer -> String
zeck n = bintodec (1 : snd (last $ takeWhile (\(x, ys) -> x > 0) $ iterate decomp (n, [])))

zeck2 :: Integer -> String
zeck2 n = bintodec (1 : snd (last $ takeWhile (\(x, ys) -> x > 0) $ iterate decompOther (n, [])))

-- printIt :: Integer -> String
-- printIt x = show x ++ "th prime = " ++ show (primes !! x) ++ ", zecked = " ++ show (zeck (primes !! x)) ++ ", split = " ++ show (primeFactors (weird (primes !! x))) ++ ", elem?: " ++ show (primes !! x `elem` primeFactors (weird (primes !! x)))

--main :: IO ()
--main = mapM_ putStrLn [printIt x | x <- [1..100]]

-- zecked?
-- something :: [Integer]
-- something = filter (\x -> primes !! x `elem` primeFactors (zeck (primes !! x))) [1..100000]

--somethingElse :: [Integer]
--somethingElse = filter (\x -> (primes !! x) `elem` primeFactors (zeck (primes !! x))) [1..100000]

-- That's a nice one
--evenWeirder :: [Integer]
--evenWeirder :: filter (\x -> 0 == zeck x `mod` x) [1..1000]



-- OK I've rediscovered https://oeis.org/A048678 also

{--
huh

Prelude Data.Numbers.Primes> weird 23
149
Prelude Data.Numbers.Primes> weird 89
593
Prelude Data.Numbers.Primes> weird 2047
1398101
Prelude Data.Numbers.Primes> primeFactors 1398101
[23,89,683] -- which just happened to be primes !! 123
--}
