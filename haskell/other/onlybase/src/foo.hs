{-
a = [1,2,3]
h = head a
t = tail a
i = init a
l = length a
n = null a -- is it empty
s = sum a
p = product a
ina = 2 `elem` a
-- ina2 = elem 3 a
r = ['a'..'z']
f5 = take 5 r
c4 = cycle "BOB "
t4b = take 4 c4
r23 = repeat 23
rep23_2 = replicate 2 23
oneToTen = [1..10]
v = [x*2 | x <- oneToTen] -- where, put in
w = [x*2 | x <- [1..10], x*2 >= 12]
x = [ x | x <- [50..100], x `mod` 7 == 3] -- [x | x <- stuff, preds]
boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
xx = [ x | x <- [10..20], x /= 13, x /= 15, x /= 19] -- /= is not equal
xy = [ x*y | x <- [2,5,10], y <- [8,10,11]]  -- <- is from
xy5 = [ x*y | x <- [2,5,10], y <- [8,10,11], x*y > 50]
nouns = ["hobo","frog","pope"]
adjectives = ["lazy","grouchy","scheming"]
rrr = [adjective ++ " " ++ noun | adjective <- adjectives, noun <- nouns]
length' xs = sum [1 | _ <- xs] -- sum one, but for how many xs there are
removeNonUppercase st = [ char | char <- st, char `elem` ['A'..'Z']]
xxs = [[1,3,5,2,3,1,2,4,5],
    [1,2,3,4,5,6,7,8,9],
    [1,2,4,2,1,6,3,1,3,2,3,6]]
xxse = [ [ x | x <- xs, even x ] | xs <- xxs]
twoTupes = [(1,2), (3, 4)]
sound = map snd twoTupes
sound2 = fst `map` twoTupes
nat = [1..]
tenNat = take 10 nat
fiveTimesNat = [x * 5 | x <- take 10 nat]
zipped = zip (take 10 nat) fiveTimesNat
rt = [ (a,b,c) | c <- [1..100], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2]
addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z
factorial :: Integer -> Integer -- eger = big
factorial n = product [1..n]
circumference :: Float -> Float
circumference r = 2 * pi * r
circumference' :: Double -> Double
circumference' r = 2 * pi * r
ee = (+) 1 2
eltee = compare 1 2
-- (Ord a) => a -> a -> Bool
-- means (<T extends Ord>T => T => bool)
ts = show 11 -- toString
fs = read "11" * 2 -- fromString!
fee = read "17289" :: Int
biggestInt = maxBound :: Int -- like typecasting but specifying a typeclass
-- div is like / but only wholes, then mod
foo = fromIntegral biggestInt
bar = biggestInt - 2
factorial2 :: (Integral a) => a -> a
factorial2 0 = 1
factorial2 n = n * factorial2 (n - 1)
main :: IO ()
main = putStrLn "Nah"
-}

main ∷ IO ()
main = pure ()
