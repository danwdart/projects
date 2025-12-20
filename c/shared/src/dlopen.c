#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

int main(int argc, char **argv) {
    char *err;

    void* handle;
    handle = dlopen("shared.so", RTLD_LAZY);
    if (!handle) {
        fprintf(stderr, "Error opening shared library: %s\n", dlerror());
        return 1;
    }
    dlerror();

    char *(*data);
    *(void **)(&data) = dlsym(handle, "data");

    // But there was nothing...

    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing data: %s\n", err);
        return 1;
    }

    char *d;
    d = (*data);

    printf("Data: (%s)\n", d);

    void* (*io)();
    *(void **) (&io) = dlsym(handle, "io");

    if ((err = dlerror()) != NULL)  {
        fprintf(stderr, "Error grabbing io: %s\n", err);
        return 1;
    }

    (*io)("Boiii");

    /* NOT: fn = (char *(*)(char *)) dlsym(handle, "fn"); */

    // char *(*fn)(char *);
    // *(void **) (&fn) = dlsym(handle, "fn");

    // if ((err = dlerror()) != NULL)  {
    //     fprintf(stderr, "Error grabbing fn: %s\n", err);
    //     return 1;
    // }

    // char *stuff;
    // stuff = (*fn)("hi");
    // printf("Stuff: %s\n", stuff);

    dlclose(handle);

    printf("Closed shared library.\n");

    return 0;
}