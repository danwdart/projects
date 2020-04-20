{-
newtype Space = Space Int

instance Show Space where
    show (Space x) = show x
    showList [] = shows ""
    showList xs = (++ fmap (\(Space x) -> show x))

grid :: [[Int]]
grid = replicate 10 $ replicate 10 0
-}

main :: IO ()
main = return ()