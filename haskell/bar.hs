import Data.Maybe

safeDiv :: (Num a, Fractional a, Eq a) => a -> a -> Maybe a
safeDiv x y = if y == 0 then Nothing else Just (x / y)

main :: IO ()
main = print (safeDiv 2 11)