#include <efi.h>
#include <efilib.h>
#include <efidebug.h>

{-# LANGUAGE ForeignFunctionInterface #-}

module Main where

{#context lib = "efi"#}

import Foreign.Ptr
{-
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.Storable
import Foreign.C.String
import Foreign.C.Types
-}

type Char16 = {#type CHAR16#}
type String16 = Ptr Char16

main :: IO ()
main = do
  -- c <- newCString "Hi!\n"
  -- let b = (castPtr c :: String16)
  -- _ <- {#call Print as printefi#} b
  -- free b
  return ()

foreign export ccall main :: IO ()