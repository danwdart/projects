-- Practice folding.
import Data.Monoid

main :: IO ()
main = do
    print . getSum $ foldMap Sum [1,2,3,4 :: Int]