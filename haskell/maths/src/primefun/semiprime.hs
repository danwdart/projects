{-# OPTIONS_GHC -Wno-unused-top-binds #-}

import Semiprimes
import Text.Tabular
-- import Text.Tabular.AsciiArt
import Text.Tabular.SimpleText

main ∷ IO ()
main = do
    putStrLn $ render
        " "
        (const "")
        (const "")
        show
        (Table (
            Group SingleLine (fmap Header [0..9 :: Integer])
            ) (
            Group SingleLine (fmap Header [0..9 :: Integer])
            ) (
            moduloMultiplication 10
        )) -- tabular
    print [s `mod` (2 ^ n) | n <- [1..10::Integer]]
