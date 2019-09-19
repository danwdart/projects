by :: (Show t1, Show t2, Show a) => (t2 -> t1 -> a) -> t1 -> t2 -> [Char]
by f n m = show n ++ " with " ++ show m ++ " = " ++ show (f m n)

dor :: (a -> a -> b) -> [a] -> [[b]]
dor f r = map (flip (map . f) r) r

resulter :: [Integer] -> [[[Char]]]
resulter = dor $ by max

result :: [[[Char]]]
result = resulter [0..10]

main :: IO ()
main = print result