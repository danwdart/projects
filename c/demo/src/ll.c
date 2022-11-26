#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../lib/libll.h"

int main(int argc, char* argv[]) {
    /* do we have to? */
    LL* list = newlist();

    char* value = "Foo";

    list->value = value;

    printlist(list, 0);

    LL* list2 = newlist();

    list2->value = "boooo";

    list->next = list2;

    printlist(list, 0);

    free(list);

    printlist(list2, 0);

    free(list2);

    return 0;
}