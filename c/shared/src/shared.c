#include <stdio.h>

char* data = "Data";

char* fn(char* param) {
    char* out;
    sprintf(out, "!! %s !!\n", param);
    // printf(out);
    return out;
}

void* io(char* param) {
    printf("!! %s !!\n", param);
}