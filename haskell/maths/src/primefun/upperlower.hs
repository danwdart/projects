module Main (main) where

import Chart
import Data.Foldable
import Factor

main :: IO ()
main = do
    -- -- A067888
    -- putStrLn "A067888"
    -- print $ fmap (\(k, _) -> k) $ filter (\(_, v) -> v == 0) $ fmap (\k -> (k, fun k)) [2..100]

    for_ [("fun", fun), ("negfun", negfun), ("absfun", absfun)] $ \(name, func) -> do
        let funResult1 = fmap func [2..100]
        print name
        print funResult1
        for_ [100, 1000, 10000 :: Integer] $ \n -> do
            let funResultE = fmap func [2..n]
            putStrLn $ name <> " to " <> show n
            seqToPng ("upperlower" <> name <> show n <> ".png") "Upper/Lower" "ul x" 2 funResultE

-- outsides :: Integer -> [Integer]
-- outsides n = fmap (floor . (sqrt :: Double -> Double) . fromIntegral) $ ([2..n] :: [Integer])

fun :: Integer -> Integer
fun n = fromIntegral (length (factors (n + 1))) - fromIntegral (length (factors (n - 1)))

negfun :: Integer -> Integer
negfun n = fromIntegral (length (factors (n - 1))) - fromIntegral (length (factors (n + 1)))

absfun :: Integer -> Integer
absfun n = abs $ fromIntegral (length (factors (n + 1))) - fromIntegral (length (factors (n - 1)))
