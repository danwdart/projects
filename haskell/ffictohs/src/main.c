#include <stdio.h>
#include <string.h>
#include "Lib_stub.h"

int main(int argc, char* argv[]) {
    hs_init(&argc, &argv);

    char* d;
    d = (*datas)();

    printf("Data: (%s)\n", d);

    (*io)();

    int result = (*add)(2);
    printf("Result: %d\n", result);

    char* stuff;
    stuff = (*fn)("hi");
    printf("Stuff: %s\n", stuff);

    return 0;
}