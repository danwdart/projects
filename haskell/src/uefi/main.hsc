#include <efi.h>
#include <efilib.h>

{-
EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
  InitializeLib(ImageHandle, SystemTable);
  Print(L"Hello, world!\n");
  return EFI_SUCCESS;
}
-}
{-# LANGUAGE ForeignFunctionInterface #-}

import Foreign.Ptr
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.C.String
import Foreign.C.Types
import System.IO


main :: IO ()
main = do
    putStrLn "Hi!"

foreign export ccall main :: IO ()