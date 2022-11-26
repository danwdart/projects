#include <stdio.h>

int main()
{
    short sov;
    short su;
    sov = sizeof(void *);
    su = sizeof(unsigned long);
    printf("The size of void* is: %d\n", sov);
    printf("The size of unsigned long is: %d\n", su);
    return 0;
}
