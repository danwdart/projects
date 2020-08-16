import Debug.Trace

iterateUntilEqual :: Eq a => (a -> a) -> a -> [a]
iterateUntilEqual f x = 

main :: IO ()
main = do
    print $ take 8 $ iterate (babylonSqrt 16) 2

babylonSqrt :: Double -> Double -> Double
babylonSqrt operand guess = ((operand / guess) + guess)/2

