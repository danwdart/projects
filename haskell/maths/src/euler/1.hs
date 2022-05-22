--result1 :: Int
--result1 = sum $ filter (\x -> mod x 5 == 0 || mod x 3 == 0) [0..999]

result2 ∷ Int
result2 = sum $ filter (\x -> any (\y -> mod x y == 0) [3,5]) [0..999]

main ∷ IO ()
main = print result2
