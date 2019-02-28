import Data.Function

splitIntIntoDigits :: Int -> [Int]
splitIntIntoDigits i = map (\x -> (read [x])) $ show i

reduceDigitsIntoInt :: [Int] -> Int
reduceDigitsIntoInt d = read $ concat $ map show d :: Int

moonArithCol :: (Int -> Int -> Int) -> [Int] -> [Int] -> [Int]
moonArithCol fn a b = reverse $ take (maxLength a b) $ zipWith fn (rppZeroes a) (rppZeroes b) where
    zeroes = repeat 0
    maxLength = on max length
    rppZeroes n = reverse n ++ zeroes

(<<+>>) :: Int -> Int -> Int
a <<+>> b = reduceDigitsIntoInt $ moonArithCol max (splitIntIntoDigits a) (splitIntIntoDigits b)

(<<*>>) :: Int -> Int -> Int
(<<*>>) = undefined

main :: IO ()
main = putStrLn $ "35 <<+>> 97 is " ++ show (39 <<+>> 97 :: Int)