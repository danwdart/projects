#include <stdio.h>
#include <stdlib.h>

int die(void) {
    perror("");
    return EXIT_FAILURE;
}

void print_file(FILE *f) {
    char *str;
    fscanf(f, "%s", str);
    printf("%s", str);
}

int with_res(void *res, int destr(FILE *res), int fn(FILE *res), int herr(void)) {
    if (!res || !fn(res)) {
        return herr();
    }

    (*destr)(res);
    return EXIT_SUCCESS;
}

void with_read_file(char *filename, void *fn) {
    with_res(fopen(filename, "r"), fclose, fn, die);
}

int main(int argc, char* argv[]) {
    if (0 == argc) {
        printf("No file specified.");
        return EXIT_SUCCESS;
    }

    char *filename = argv[1];

    with_read_file(filename, print_file);

    return EXIT_SUCCESS;
}