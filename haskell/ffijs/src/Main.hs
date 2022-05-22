{-# LANGUAGE JavaScriptFFI #-}
{-# LANGUAGE CPP     #-}

module Main where

import Foreign.C ( CString, newCString, peekCString )
import Control.Monad ( (>=>) )

#ifdef DYNAMIC_LIBRARY

import GHC.Ptr
import System.Posix.DynamicLinker

foreign import javascript "dynamic" mkData :: FunPtr CString -> CString -- pure?
foreign import javascript "dynamic" mkIO :: FunPtr (IO ()) -> IO ()
foreign import javascript "dynamic" mkFn :: FunPtr (CString -> IO CString) -> (CString -> IO CString)
foreign import javascript "dynamic" mkAdd :: FunPtr (Int -> Int) -> (Int -> Int)

#else

foreign import javascript "data" datas :: CString
foreign import javascript "io" io :: IO ()
foreign import javascript "fn" fn :: CString -> IO CString
foreign import javascript "add" add :: Int -> Int

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