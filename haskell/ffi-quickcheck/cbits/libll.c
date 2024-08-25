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

LL* from_array(char *array[], int size) {
    LL* list = newlist();
    LL* orig_list = list;
    for (int i = 0; i < size; i++) {
        list->value = array[i];
        list->next = newlist();
        list = list->next;
    }    
    return orig_list;
}

void insert(char *value, LL* list) {
    char **tracer;

    
}