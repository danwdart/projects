#include <stdio.h>
#include <string.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <unistd.h>

static char n_s[16] = {0};
static char size_s[16] = {0};
static char addr_s[16] = {0};

/* perhaps a printf without a malloc or original malloc here */

/* puts and printf might call malloc if we call them within it */
void debug_memlog(char *func, size_t n, size_t size, void *mem) {
    write(0, "Called ", 7);
    write(0, func, strlen(func));

    if (n > 0) {
        write(0, ", regarding ", 13);
        memset(n_s, 0, 16);
        sprintf(n_s, "%d", (int)n);
        write(0, n_s, 16);
        write(0, " blocks", 8);
    }

    if (size > 0) {
        write(0, ", for size ", 12);
        memset(size_s, 0, 16);
        sprintf(size_s, "%d", (int)size);
        write(0, size_s, 16);
    }
    
    if (mem != NULL) {
        write(0, " and it was at address ", 24);
        memset(addr_s, 0, 16);
        sprintf(addr_s, "%p", mem);
        write(0, addr_s, 16);
    }

    if (mem == NULL) {
        write(0, " on a null pointer!", 20);
    }

    if (size == 0) {
        size = 128;
    }

    if (n == 0) {
        n = 1;
    }

    write(0, " and mem looks like: ", 22);
    write(0, (char*)mem, size * n);
    /*
    log where and how much...
    then show the actual memory that's just about to be returned or freed here
    */
    write(0, "\n", 1);
}

void *malloc(size_t size) {
    void* (*orig_malloc)(size_t) = dlsym(RTLD_NEXT, "malloc");

    void *mem = orig_malloc(size);

    debug_memlog("malloc", 1, size, mem);

    return mem;
}

void free(void *p) {
    debug_memlog("free", 0, 0, p);

    void (*orig_free)(void *) = dlsym(RTLD_NEXT, "free");

    return orig_free(p);
}

void *calloc(size_t n, size_t size) {
    void* (*orig_calloc)(size_t, size_t) = dlsym(RTLD_NEXT, "calloc");
    
    void *mem = orig_calloc(n, size);

    debug_memlog("calloc", n, size, mem);

    return mem;
}

void *realloc(void *p, size_t size) {
    debug_memlog("realloc before", 1, size, p);

    void* (*orig_realloc)(void *, size_t) = dlsym(RTLD_NEXT, "realloc");

    void* mem = orig_realloc(p, size);

    debug_memlog("realloc after", 1, size, mem);

    return mem;
}

void *reallocarray(void *p, size_t n, size_t size) {
    debug_memlog("reallocarray before", n, size, p);

    void* (*orig_reallocarray)(void *, size_t, size_t) = dlsym(RTLD_NEXT, "reallocarray");

    void *mem = orig_reallocarray(p, n, size);

    debug_memlog("reallocarray after", n, size, mem);

    return mem;
}