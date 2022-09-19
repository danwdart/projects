module Main where

-- >>> rootRationalApproxNext 9 $ rootRationalApproxNext 9 $ rootRationalApproxNext 9 $ rootRationalApproxNext 9 $ rootRationalApproxNext 9 2
-- 11641532182693481445313 % 3880510727564493815104
--

-- https://math.stackexchange.com/questions/1720860/rational-approximation-of-square-roots
rootRationalApproxNext :: Rational -> Rational -> Rational
rootRationalApproxNext num guess = guess - ((guess * guess - num) / (2 * guess))

-- >>> rootRationalApprox 9 1

rootRationalApprox :: Rational -> Rational -> Rational
rootRationalApprox num guess = iterate (rootRationalApproxNext num) guess !! 15

main :: IO ()
main = do
    print $ rootRationalApprox 9 1
    putStrLn "Or, if you like..."
    print (fromRational $ rootRationalApprox 9 1 :: Double)