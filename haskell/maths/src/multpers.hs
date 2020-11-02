import           Data.List.Nub
import           Data.List.Repeat

main :: IO ()
main = mapM_ print $ records 100000

step :: Integer -> Integer
step = product . fmap (read . (: [])) . show

pers :: Integer -> Int
pers = pred . length . takeUntilRepeat . iterate step

records :: Integer -> [(Integer, Int)]
records n = nubOn snd $ ((,) <$> id <*> pers) <$> [1..n]
