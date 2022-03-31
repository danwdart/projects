#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    printf("Hello World!\n");
    printf("The number of arguments was %d\n", argc);
    for (int c = 0; c < argc; c++) {
        printf("The argument at %d was %s\n", c, argv[c]);
    }
    printf("I'm done now.\n");

    if (0 == argc) {
        printf("No file specified.");
        return EXIT_SUCCESS;
    }

    char *filename = argv[1];

    FILE *f = fopen(filename, "r");

    if (0 == f) {
        perror("Caught error");
        return EXIT_FAILURE;
    }
    
    char *str;

    if (!fscanf(f, "%s", str)) {
        printf("File contents: %s\n", str);
    } else {
        perror("What just happened?");
        return EXIT_FAILURE;
    }

    fclose(f);

    return EXIT_SUCCESS;
}