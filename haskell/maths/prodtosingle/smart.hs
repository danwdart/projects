takeWhileInclusive :: (a -> Bool) -> [a] -> [a]
takeWhileInclusive _ [] = []
takeWhileInclusive p (x:xs) = x : if p x then takeWhileInclusive p xs
                                         else []

intToList :: Integer -> [Integer]
intToList n = map (\c -> read [c]) (show n) :: [Integer]

pts :: Integer -> Integer
pts = product . intToList

res2 n = tail $ takeWhileInclusive (\n -> length (show n) > 1) (iterate pts n)

res n ns = show n ++ " -> " ++ show ns ++ " (length: " ++ show (length ns) ++ ")"

numGen = [1000000..1000000000]

result :: [String]
result = map (\n -> res n (res2 n)) $ filter (\n -> length (res2 n) > 7) numGen
    
main :: IO ()
main = mapM_ putStrLn result