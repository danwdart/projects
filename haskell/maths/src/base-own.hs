{-# OPTIONS_GHC -Wno-unused-matches -Wno-unused-top-binds #-}

toBase :: Integer -> Integer -> [Integer]
toBase b n = case divMod n b of
    (0, m) -> [m]
    (d, m) -> m : toBase b d -- ?

fromBase :: Integer -> [Integer] -> Integer
fromBase _ [] = 0
fromBase b (n:ns) = n + b * fromBase b ns

main :: IO ()
main = print $ fromBase 2 $ toBase 2 129