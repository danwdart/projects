#include <stdio.h>
int main(int argc, char **argv)
{
    long unsigned addr;
    short i;
    for(i=0;i<argc;i++) {
        addr = (long unsigned)&argv[i];

        printf("%d arg is %s at %lu\n", i, argv[i], addr);
    }
    return 0;
}
