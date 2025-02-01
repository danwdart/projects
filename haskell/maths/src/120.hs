module Main (main) where

import Data.Foldable

-- import Data.Foldable

{-
120 has some interesting numbers.
120 is highly composite.
121 is 11²
122 is 2 · 61
123 is in decimal algebraic series
124 is in decimal geometric series
125 is 5³
126 is 2 · 3 · 3 · 7
127 is a Mersenne prime.
128 is 2⁷
129 is an RSA challenge.

We've got three powers here within 7 of each other.

Some of these add up with other powers.

E.g. 11² + 4² = 5³
11² + 7 = 2⁷
5³ + 3 = 2⁷

Hmmm, a^x + b = c^b?

I wonder what other numbers are close powers, or additions of powers?

Found using this code:

3³ + 5 = 2⁵

I don't think there are any more because powers diverge from one another.
-}

-- import Data.List

{-
result1 :: [String]
result1 = [show a ++ "^" ++ show x ++ " + " ++ show b ++ " = " ++ show c ++ "^" ++ show b |
    a <- [1..1000], b <- [2..10], c <- [2..1000], x <- [2..10],
    a ^ x + b == c ^ b]
-}

data NextPower = NextPower {
    power     :: Integer,
    product   :: Integer,
    remainder :: Integer
} deriving stock (Show)

{-
nextP :: (Integral a, Num a) => a -> a -> NextPower
nextP base num = let
    pow = ceiling (logBase (fromIntegral base) (fromIntegral num))
    prod = 2 ^ pow
    in NextPower pow prod (fromIntegral (prod - (fromIntegral num)))
-}

{-
primeFactors :: (Integral a) => a -> [a]
primeFactors n =
    case factors of
        [] -> [n]
        _  -> factors ++ primeFactors (n `div` (head factors))
    where factors = take 1 $ filter (\x -> (n `mod` x) == 0) [2 .. n-1]
-}

{-
result2 :: [String]
result2 = [
    let np = nextP 2 (a ^ b)
    in
    show a ++ "^" ++ show b ++ " + " ++  intercalate " · " (map show (primeFactors (remainder np))) ++ " = 2^" ++ show (power np) |
    a <- [3..20], b <- [2..10]]

    -- (2 * a) ^ b + (2 ^ b * c) = 2 ^ d

    -- (3^6 + 5 * 59) = 2^10

result3 :: [String]
result3 = [
    let nP = nextP 2 (a ^ b)
    in show a ++ ", " ++ show b ++ ", " ++ show (power nP)|
    a <- [2..10], b <- [2..10]]
-}

result4 ∷ [String]
result4 = [
    let pwr = a ^ b :: Integer
        pwr2 = floor (logBase (fromInteger c) (fromInteger pwr) :: Double) :: Integer
        res2 =  c ^ pwr2 :: Integer
        res = pwr - res2 :: Integer
    in
        show a <> (" ^ " <> (show b <> (" - " <> (show c <> (" ^ " <> (show pwr2 <> (" = " <> show res))))))) |
    a <- [2..10] :: [Integer], b <- [2..10] :: [Integer], c <- [2..10] :: [Integer]]

main ∷ IO ()
main = traverse_ putStrLn result4

