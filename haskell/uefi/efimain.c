#include <efi.h>
#include <efilib.h>
EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
  InitializeLib(ImageHandle, SystemTable);
  Print(L"Hello, world!\n");
  // hs_init(0,0);
  // main();
  // hs_exit();
  return EFI_SUCCESS;
}