caser :: Char -> String
caser 'a' = "Ah"
caser 'b' = "Br";

wholeListAndPartOfList :: (Show a) => [a] -> String
wholeListAndPartOfList [] = "Nothing"
wholeListAndPartOfList whole@(x:xs) = "x = " ++ show x ++ " and xs = " ++ show xs

capital :: String -> String  
capital "" = "Empty string, whoops!"  
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]  

casesByGuard :: (Ord a, Num a) => a -> String
casesByGuard x
    | x >= 2 = ">= two"
    | x >= 1 = ">= one"
    | otherwise = "under one"
    where y = x * 2

main :: IO ()
main = putStrLn (casesByGuard 0)