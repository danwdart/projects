#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libll.h"

LL* newlist() {
    return (LL*) malloc(sizeof(LL)); /* why: https://stackoverflow.com/questions/26206667/do-we-have-to-malloc-a-struct */
}

void* printlist(LL* list, int from) {
    printf("%d: %s\n", from, list->value);

    if (NULL != list->next) {
        printlist(list->next, from + 1);
    }
}