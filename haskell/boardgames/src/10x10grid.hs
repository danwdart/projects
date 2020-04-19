newtype Space = Space Int

instance Show Space where
    show (Space x) = show x
    showList [] = shows ""
    showList (Space x:xs) = (++ show x)

grid :: [[Int]]
grid = replicate 10 $ replicate 10 0