#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static char size_s[16];

/* puts and printf might call malloc if we call them within it */
void debug_memfuck(char *func, size_t size) {
    write(0, "Called ", 7);
    write(0, func, strlen(func));
    write(0, " which asked for ", 18);
    memset(size_s, 0, 16);
    sprintf(size_s, "%d", size);
    write(0, size_s, 12);
    write(0, " but fucked it up on purpose. Say goodbye to your heap! Mwahahaha!\n", 68);
}

void *malloc(size_t size) {
    debug_memfuck("malloc", size);

    return NULL;
}

void free(void *p) {
    debug_memfuck("free", 0);
}

void *calloc(size_t n, size_t size) {
    debug_memfuck("calloc", size);
    
    return NULL;
}

void *realloc(void *p, size_t size) {
    debug_memfuck("realloc", size);

    return NULL;
}

void *reallocarray(void *p, size_t n, size_t size) {
    debug_memfuck("reallocarray", n * size);

    return NULL;
}