#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct ll {
    char* value;
    struct ll* next;
} LL;

LL* newlist();

void* printlist(LL* list, int from);