{-# LANGUAGE CApiFFI #-}
{-# LANGUAGE CPP     #-}

module Main where

import Foreign.C

#ifdef DYNAMIC_LIBRARY

import GHC.Ptr
import System.Posix.DynamicLinker

foreign import capi "dynamic" mkData :: FunPtr CString -> CString -- pure?
foreign import capi "dynamic" mkIO :: FunPtr (IO ()) -> IO ()
foreign import capi "dynamic" mkFn :: FunPtr (CString -> IO CString) -> (CString -> IO CString)
foreign import capi "dynamic" mkAdd :: FunPtr (Int -> Int) -> (Int -> Int)

#else

foreign import capi "libdemo.h data" datas :: CString
foreign import capi "libdemo.h io" io :: IO ()
foreign import capi "libdemo.h fn" fn :: CString -> IO CString
foreign import capi "libdemo.h add" add :: Int -> Int

#endif

main :: IO ()
main = do
#ifdef DYNAMIC_LIBRARY
    libHandler <- dlopen "lib.so" [RTLD_LAZY]
    datas <- mkData <$> dlsym libHandler "data"
    io <- mkIO <$> dlsym libHandler "io"
    fn <- mkFn <$> dlsym libHandler "fn"
    add <- mkAdd <$> dlsym libHandler "add"
#endif
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
#ifdef _DYNAMIC_LIB
    dlclose libHandler -- handling fns
#endif