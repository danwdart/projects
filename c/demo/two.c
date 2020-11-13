#include <stdio.h>
int main()
{
    float fIn;
    int ref;
    scanf("%f", &fIn);
    ref = *(int *)&fIn;
    printf("%x\n", ref);
    return 0;
}
