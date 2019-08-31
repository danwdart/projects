import Data.List

hash :: Double -> Int
hash = read . sort . take 6 . filter (/='0') . drop 1 . dropWhile (/='.')  . show . (** 0.03125)

main :: IO ()
main = print $ map (floor . fst) . filter ((==234477) . snd) $ map (\x -> (x, hash x)) [2..1000000]