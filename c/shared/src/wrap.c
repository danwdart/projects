#include <stdio.h>

void _start() {
    printf("Not starting.\n");
}

void __libc_start() {
    printf("Overwrote libc start. Mwahahaha.\n");
}