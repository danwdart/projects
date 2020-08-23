import           Data.Ratio

toNums :: Int -> [Int] -> [Int]
toNums a = fmap (numerator . (% a))

toNumList :: Int -> [Int]
toNumList a = toNums a [1..(a-1)]

-- A112544
bigList :: [Int]
bigList = concat $ toNumList <$> [2..20]

triangleList :: String
triangleList = unlines $ fmap show $ toNumList <$> [2..40]

main :: IO ()
main = putStrLn triangleList

-- Mine
sumList :: [Int]
sumList = sum . toNumList <$> [2..200]
