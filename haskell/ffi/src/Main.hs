{-# LANGUAGE CApiFFI #-}
{-# LANGUAGE CPP     #-}

module Main where

import Foreign.C ( CString, newCString, peekCString )
import Control.Monad ( (>=>) )

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

run :: CString -> IO () -> (CString -> IO CString) -> (Int -> Int) -> IO ()
run datas' io' fn' add' = do
    dataS <- peekCString datas'
    putStrLn dataS

    io'

    let wrappedFn = newCString >=> fn' >=> peekCString
    ah <- wrappedFn "Hi!"
    putStrLn $ "Answer: " <> ah

    let k = add' 2
    print k

main :: IO ()
main = do
#ifdef DYNAMIC_LIBRARY
    withDL "libdemo.so" [RTLD_LAZY] $ \libHandler -> do
        datas <- mkData <$> dlsym libHandler "data"
        io <- mkIO <$> dlsym libHandler "io"
        fn <- mkFn <$> dlsym libHandler "fn"
        add <- mkAdd <$> dlsym libHandler "add"
#endif
        run datas io fn add