#include <stdio.h>
#include <string.h>

#ifdef DYNAMIC_LIBRARY
#include <dlfcn.h>
#else
#include "LibDemo_stub.h"
#endif

int main(int argc, char* argv[]) {
    
    #ifdef DYNAMIC_LIBRARY

    char* err;

    void* handle;
    handle = dlopen("libHSLibDemo.so", RTLD_LAZY);
    if (!handle) {
        fprintf(stderr, "Error opening shared library: %s\n", dlerror());
        return 1;
    }
    dlerror();

    // static char *argv_N[] = { NULL }, **argv_ = argv_N;
    // static int argc_ = 0;
    void (*hs_init)(int *argc, char **argv[]) = dlsym(handle, "hs_init");

    char* (*data)();
    *(void **)(&data) = dlsym(handle, "data");

    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing data: %s\n", err);
        return 1;
    }

    void* (*io)();
    *(void **) (&io) = dlsym(handle, "io");

    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing io: %s\n", err);
        return 1;
    }

    int (*add)(int);
    *(void **) (&add) = dlsym(handle, "add");
    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing add: %s\n", err);
        return 1;
    }

    char* (*fn)(char*);
    *(void **) (&fn) = dlsym(handle, "fn");
    
    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing fn: %s\n", err);
        return 1;
    }

    void (*hs_exit)() = dlsym(handle, "hs_exit");
    
    #endif

    hs_init(&argc, &argv);

    char* d;
    d = (*data)();

    printf("Data: (%s)\n", d);

    (*io)(); // ("Boiii");

    int result = (*add)(2);
    printf("Result: %d\n", result);

    char* stuff;
    stuff = (*fn)("hi");
    printf("Stuff: %s\n", stuff);

    hs_exit();

    #ifdef DYNAMIC_LIBRARY
    dlclose(handle);
    #endif

    return 0;
}