#include "../uefi/uefi.h"
#include "KMain_stub.h"

int main(int argc, char *argv[]) {
    hs_init(&argc, &argv);
    /* hs_run(); */
    kmain();
    hs_exit();
    return 0;
}