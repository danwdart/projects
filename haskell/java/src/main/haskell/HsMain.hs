{-# LANGUAGE ForeignFunctionInterface #-}

module HsMain where

import Foreign.C.Types

hsMain :: IO ()
hsMain = putStrLn "Hello World!"

foreign export ccall hsMain :: IO ()