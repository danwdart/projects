#include <uefi.h>
#include "hsmain_stub.h"

int main(int argc, char *argv[]) {
    hs_init(&argc, &argv);
    /* hs_run(); */
    kmain();
    return 0;
}