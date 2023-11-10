{-# LANGUAGE RebindableSyntax #-}

module Main (main) where

import Prelude hiding (return, (>>), (>>=))

ints ∷ Int
ints = do
    1
    2
    3
    4
    5
    where
        (>>) ∷ Int → Int → Int
        (>>) = (+)

main ∷ IO ()
main = print ints
