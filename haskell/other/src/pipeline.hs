import Data.Function

a :: Int -> Int
a = (+10)

b :: Int
b = 5

-- c = a(a(a(a b)))
-- c = a $ a $ a $ a $ b
c :: Int
c = b & a & a & a & a

main :: IO ()
main = print c