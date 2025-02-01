#include "interface.h"

void initialise(void) {
    printf("%s", "Hello World!\n");
}

void printversion(void) {

}

int magic_number(void) {

}

char *version = "0.1";

char *getversion(void) {
    return version;
}

void deinitialise(void) {
    printf("%s", "Goodbye World!\n");
}