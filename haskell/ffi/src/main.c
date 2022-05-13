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
    #ifdef HELPER_MODULE
    handle = dlopen("libHSDemo_withhelper.so", RTLD_LAZY);
    #else
    handle = dlopen("libHSDemo.so", RTLD_LAZY);
    #endif
    if (!handle) {
        fprintf(stderr, "Error opening shared library: %s\n", dlerror());
        return 1;
    }
    dlerror();

    #ifndef HELPER_MODULE
    // static char *argv_N[] = { NULL }, **argv_ = argv_N;
    // static int argc_ = 0;
    void (*hs_init)(int *argc, char **argv[]) = dlsym(handle, "hs_init");
    #endif

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

    #ifndef HELPER_MODULE
    void (*hs_exit)() = dlsym(handle, "hs_exit");
    #endif

    #endif

    #ifndef HELPER_MODULE
    hs_init(&argc, &argv);
    #endif

    char* d;
    d = (*data)();

    printf("Data: (%s)\n", d);

    (*io)(); // ("Boiii");

    int result = (*add)(2);
    printf("Result: %d\n", result);

    char* stuff;
    stuff = (*fn)("hi");
    printf("Stuff: %s\n", stuff);

    #ifndef HELPER_MODULE
    hs_exit();
    #endif

    #ifdef DYNAMIC_LIBRARY
    dlclose(handle);
    #endif

    return 0;
}