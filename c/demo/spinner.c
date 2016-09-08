#include <stdio.h>
int i;
char spin[4] = { '|', '/', '-', '\\' };
void main() {
    printf("%s", "Doing something...");
    for(i=0;;usleep(50000), fflush(stdout))
        printf("\x08\x08 %c", spin[++i%4]);
}
