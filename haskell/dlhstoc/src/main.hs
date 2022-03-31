{-# LANGUAGE CApiFFI #-}

module Main where

import Foreign.C
import GHC.Ptr
import System.Posix.DynamicLinker

foreign import capi "dynamic" mkData :: FunPtr CString -> CString -- pure?
foreign import capi "dynamic" mkIO :: FunPtr (IO ()) -> IO ()
foreign import capi "dynamic" mkFn :: FunPtr (CString -> IO CString) -> (CString -> IO CString)
foreign import capi "dynamic" mkAdd :: FunPtr (Int -> Int) -> (Int -> Int)

main :: IO ()
main = do
    libHandler <- dlopen "lib.so" [RTLD_LAZY]
    datas <- mkData <$> dlsym libHandler "data"
    io <- mkIO <$> dlsym libHandler "io"
    fn <- mkFn <$> dlsym libHandler "fn"
    add <- mkAdd <$> dlsym libHandler "add"

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

    dlclose libHandler -- handling fns