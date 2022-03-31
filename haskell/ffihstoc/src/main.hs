{-# LANGUAGE CApiFFI #-}

module Main where

import Foreign.C

foreign import capi "lib.h data" datas :: CString
foreign import capi "lib.h io" io :: IO ()
foreign import capi "lib.h fn" fn :: CString -> IO CString
foreign import capi "lib.h add" add :: Int -> Int

main :: IO ()
main = do
    let datacret = datas
    dataS <- peekCString datacret
    putStrLn dataS

    io

    cin <- newCString "Hi!"
    a <- fn cin
    ah <- peekCString a
    putStrLn $ "Result: " <> ah

    let k = add 2
    print k