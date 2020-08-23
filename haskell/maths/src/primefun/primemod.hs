import           Control.Arrow
import           Data.List

mk ::Int -> [[Int]]
mk k = map (\ n -> map (\ m -> (n * m) `mod` k) [0 .. n]) [0 .. k - 1]

fn :: Int -> (Int, [Int])
fn p = (p,
    map fst $
        filter (\ x -> snd x == 1) $
        (map (head &&& length) . group . sort) $ concat $ mk p
    )

main :: IO ()
main = mapM_ (print . fn) [1 .. 10]
