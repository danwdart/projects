{-# OPTIONS_GHC -Wno-unused-imports #-}

import Foreign

i :: Int
i = 12345

main :: IO ()
main = do
    a <- new i
    print a
    a' <- peek a
    print a'
    poke a 1
    b' <- peek a
    print b'

    mapM_ (\n -> do
        let p = plusPtr a (negate n) :: Ptr Int
        p' <- peek p :: IO Int
        print (n, p')
        ) [1..10384]