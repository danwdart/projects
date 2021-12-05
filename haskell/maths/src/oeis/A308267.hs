-- Numbers which divide their Zeckendorffian format exactly.

bintodec :: [Integer] -> Integer
bintodec = sum . zipWith (*) (iterate (*2) 1) . reverse

decomp :: (Integer, [Integer]) -> (Integer, [Integer])
decomp (x, ys) = if even x then (x `div` 2, 0:ys) else (x - 1, 1:ys)

zeck :: Integer -> Integer
zeck n = bintodec (1 : snd (last . takeWhile (\(x, _) -> x > 0) $ iterate decomp (n, [])))

output :: [Integer]
output = filter (\x -> 0 == zeck x `mod` x) [1..100] 

main :: IO ()
main = print output