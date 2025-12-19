#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
    srand(time(NULL));

    printf("Here is a random number: %d", rand());
    
    return 0;
}  