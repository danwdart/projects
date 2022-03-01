#include <stdio.h>
#include "Lib_stub.h"

int main(int argc, char *argv[]) {
    hs_init(&argc, &argv);
    /* hs_run(); */
    printf("Hello from C!\n");
    lib();
    hs_exit();
    return 0;
}