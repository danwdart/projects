#include <efi/efi.h>
#include <efi/efilib.h>

{-# LANGUAGE ForeignFunctionInterface #-}

import Foreign.Ptr
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.C.String
import Foreign.C.Types
import System.IO

foreign import ccall "SystemTable" systemTable :: Ptr [CString]

main :: IO ()
main = do
    putStrLn "Hi!"
    print bob