import Control.Monad

allEq :: (Eq a) => [a] -> Bool
allEq [] = False
allEq (x:xs) = all (== x) xs

result :: [Int]
result = ([1..10] >>= \x -> [1..5] >>= \y -> [x * y])

result2 :: [Int]
result2 = (*) <$> [1..10] <*> [1..5]

result3 :: [Int]
result3 = liftM2 (*) [1..10] [1..5]

main :: IO ()
main = print $ allEq [
    result,
    result2,
    result3]