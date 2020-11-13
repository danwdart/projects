#include <stdio.h>
int main()
{
    short sov;
    short su;
    sov = sizeof(void *);
    su = sizeof(unsigned long);
    printf("%d\n", sov);
    printf("%d\n", su);
    return 0;
}
