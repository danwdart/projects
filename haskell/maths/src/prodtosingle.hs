{-# LANGUAGE UnicodeSyntax #-}
import           Data.Function
import           Data.List

-- charToInteger :: Char -> Integer
-- charToInteger y = read [y]

integerToDigits ∷ Integer → [Integer]
integerToDigits n = (\y -> read [y] :: Integer) <$> show n

-- digitsToInteger :: [Integer] -> Integer
-- digitsToInteger xs = read $ concatMap show xs :: Integer

integerToProd ∷ Integer → Integer
integerToProd = product . integerToDigits

takeWhileOneMore ∷ (a → Bool) -> [a] -> [a]
takeWhileOneMore p = foldr (\y ys -> if p y then y:ys else [y]) []

intsToPrintList ∷ [Integer] → String
intsToPrintList xs = intercalate  ", " (fmap show xs)

-- length $ filter (==0) $ map integerToProd [1..1000]

breakDown ∷ Integer → [Integer]
breakDown n = takeWhileOneMore (>10) $ iterate integerToProd n

data MyStruct = MyStruct {
    x   :: Integer,
    lbd :: Int,
    bd  :: [Integer]
}

instance Eq MyStruct where (==) = on (==) lbd
instance Ord MyStruct where compare = on compare lbd
instance Show MyStruct where show ms = show (x ms) <> (": " <> (show (lbd ms) <> (" steps: " <> intsToPrintList (bd ms))))

myStruct ∷ Integer → MyStruct
myStruct y = MyStruct y (length (breakDown y) - 1) (breakDown y)

outputNaive ∷ [MyStruct]
outputNaive = nub $ fmap myStruct [1..1000000]

-- iCombo :: Int -> Int -> [[Int]]
-- iCombo n m = replicate <$> [0..n] <*> [m]

-- makeCombos :: Int -> [[Int]]
-- makeCombos upTo = (++) <$> ((++) <$> ((++) <$> iCombo upTo 3 <*> iCombo upTo 7) <*> iCombo upTo 8) <*> iCombo upTo 9

-- allCombos :: [Integer]
-- allCombos = map digitsToInteger $ dropWhile null $ makeCombos 25

-- outputTwo :: [MyStruct]
-- outputTwo = nub $ map myStruct allCombos

-- By formula
-- mapM_ print $ nubBy (on (==) snd) $ map (\(n, x) -> (n, length (breakDown x) - 1)) [(n, 10^n-1) | n <- [1..1000]]


main ∷ IO ()
main = mapM_ print outputNaive
