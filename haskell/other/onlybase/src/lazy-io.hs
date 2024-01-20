{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main where

import Debug.Trace

data A = A {
    a :: Int,
    b :: String
}

data B = B {
    c :: Int,
    d :: A
}

mkAIO :: IO A
mkAIO = pure $ trace "Making A" $ A 1 "Yo"

mkBIO :: IO B
mkBIO = do
    a <- mkAIO
    pure $ trace "Making B" $ B 1 a

main :: IO ()
main = do
    b <- mkBIO
    print $ c b
    b2 <- mkBIO
    print $ c b2
