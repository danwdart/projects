#include <stdio.h>
#include <string.h>

// Haskell can't import primitives.
extern char* data(void) {
    return "Data";
}

extern void io(void) {
    printf("Hello from C!\n");
}

extern char* fn(char* x) {
    char* out = x;
    printf(out);
    return out;
}

extern int add(int x) {
    return x + 42;
}