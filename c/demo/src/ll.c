#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../lib/libll.h"

int main(int argc, char **argv) {
    char *items[] = {
        "apple",
        "banana",
        "clementine",
        "dragonfruit",
        "example",
        "fumble",
        "grapefruit"
    };

    LL *stuff = from_array(items, sizeof(items) / sizeof(items[0]));
    printlist(stuff, 0);
    free(stuff);

    printf("%s", "And now for something completely different.\n");

    /* do we have to? */
    LL* list = newlist();

    list->value = "foo";

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