#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

#ifdef _IS_DYNAMIC
#include "Lib_stub.h"
#endif

int main(int argc, char* argv[]) {
    char* err;

    void* handle;
    handle = dlopen("libHSLib.so", RTLD_LAZY);
    if (!handle) {
        fprintf(stderr, "Error opening shared library: %s\n", dlerror());
        return 1;
    }
    dlerror();

    #ifdef _IS_DYNAMIC
    hs_init(&argc, &argv);
    #else
    static char *argv_N[] = { NULL }, **argv_ = argv_N;
    static int argc_ = 0;
    void (*hs_init_l)(int *argc, char **argv[]) = dlsym(handle, "hs_init");
    hs_init_l(&argc_, &argv_);
    #endif
    
    char* (*data)();
    *(void **)(&data) = dlsym(handle, "datas"); // haha, data

    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing data: %s\n", err);
        return 1;
    }

    char* d;
    d = (*data)();

    printf("Data: (%s)\n", d);
   
    void* (*io)();
    *(void **) (&io) = dlsym(handle, "io");

    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing io: %s\n", err);
        return 1;
    }

    (*io)("Boiii"); // ("Boiii");

    int (*add)(int);
    *(void **) (&add) = dlsym(handle, "add");
    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing add: %s\n", err);
        return 1;
    }

    int result = (*add)(2);
    printf("Result: %d\n", result);


    char* (*fn)(char*);
    *(void **) (&fn) = dlsym(handle, "fn");
    
    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing fn: %s\n", err);
        return 1;
    }

    char* stuff;
    stuff = (*fn)("hi");
    printf("Stuff: %s\n", stuff);
   
    dlclose(handle);

    return 0;
}