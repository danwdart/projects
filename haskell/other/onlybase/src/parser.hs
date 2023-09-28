{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-orphans #-}

import Parser

main ∷ IO ()
main = putStrLn . either show show $ (snd <$> runParser strNumJ " { \"bobby mcgoo\" : 66 : 78,09,87,449,3238626433832795028 }")
