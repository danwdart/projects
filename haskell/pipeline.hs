import Data.Function

a = (+10)
b = 5

-- c = a(a(a(a b)))
-- c = a $ a $ a $ a $ b
c = b & a & a & a & a

main = print c