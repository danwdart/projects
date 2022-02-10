{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-imports -Wno-type-defaults -Wno-unused-top-binds -Wno-unused-matches #-}

import           Data.Digits

{-# ANN module "HLint: ignore" #-}

main :: IO ()
main = pure ()

-- $>  (,) <$> id <*> happify 3 10 <$> [1..1000]

happify :: Int -> Int -> Int -> Int
happify power base = sum . fmap (^ power) . digits base