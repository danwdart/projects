{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-top-binds #-}

module Main (main) where

import Debug.Trace

data A = A {
    a :: Int,
    b :: String
}

data A2 = A2 {
    a2 :: Int,
    b2 :: String
}

data B = B {
    c :: Int,
    d :: A
}

data B2 = B2 {
    c2 :: Int,
    d2 :: A2
}

mkA2 ∷ A2
mkA2 = trace "Making A2" $ A2 1 "Yo"

mkB2 ∷ A2 → B2
mkB2 = trace "Making B2" . B2 1

mkAIO ∷ IO A
mkAIO = trace "mkAIO" . pure . trace "Making A" $ A 1 "Yo"

mkBIO ∷ IO B
mkBIO = do
    trace "Making B in IO" . B 1 <$> mkAIO

main ∷ IO ()
main = do
    let b2_1 = mkB2 mkA2
    print $ c2 b2_1
    bIO <- mkBIO
    print $ c bIO

    putStrLn "Again!!"
    let b2_2 = mkB2 mkA2
    print $ c2 b2_2
    bIO2 <- mkBIO
    print $ c bIO2
