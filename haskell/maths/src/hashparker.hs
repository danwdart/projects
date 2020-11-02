{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import           Data.List

hash :: Double -> Int
hash = read . sort . take 6 . filter (/='0') . drop 1 . dropWhile (/='.')  . show . (** 0.03125)

results :: [Integer]
results = map (floor . fst) . filter ((==234477) . snd) $ map (\x -> (x, hash x)) ([2..1000000] :: [Double])

hashes :: [Int]
hashes = fmap hash ([2..1000] :: [Double])

main :: IO ()
main = print results
