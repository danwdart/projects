#include <efi.h>
#include <efilib.h>
#include <efidebug.h>

{-# LANGUAGE ForeignFunctionInterface #-}

import Foreign.Ptr
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.C.String
import Foreign.C.Types

foreign import ccall "efilib.h Print"
  printefi :: CWString -> IO CULong

foreign import ccall "efidebug.h DbgPrint"
  dbgPrint :: CInt -> CString -> IO CInt

foreign import ccall "efidebug.h D_INFO"
  dInfo :: CInt

main :: IO ()
main = do
  s <- newCWString "Hi from Haskell\n"
  _ <- printefi s
  i <- newCString "Hello!!\n"
  _ <- dbgPrint dInfo i
  free s
  return ()

foreign export ccall main :: IO ()