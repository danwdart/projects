#include <stdio.h>
#include <string.h>
#include "../lib/libheap.h"

int main(int argc, char* argv[])
{
    printf("Allocating...");

    char *allocated = heap_alloc(10);

    strcpy(allocated, "Hello World!"); // Oh no, overflow! What do?

    printf("%s", allocated);

    heap_free(allocated);

    heap_collect();

    return 0;
}