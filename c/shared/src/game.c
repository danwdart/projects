#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
    srand(time(NULL));

    int randno = rand();

    printf("Here is a random number: %d", randno);
    
    return 0;
}