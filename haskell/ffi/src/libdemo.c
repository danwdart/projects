#include <stdio.h>
#include "libdemo.h"

char* question = "What is the answer to life, the universe and everything?";

int answer = 42;

extern char* data(void) {
    return "Data";
}

extern void io(void) {
    printf("Hello from C!\n");
}

extern char* fn(char* x) {
    char* out = "";
    out = x;
    printf(out);
    return out;
}

extern int add(int x) {
    return x + 42;
}