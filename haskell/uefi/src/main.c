#include <uefi.h>
#include "hsmain_stub.h"

int main(void) {
    hs_init(void 0, void 0);
    /* hs_run(); */
    kmain();
    return 0;
}