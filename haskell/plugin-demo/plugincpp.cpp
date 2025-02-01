#include <iostream>
#include "plugin.h"

extern "C" {
void initialise(void) {
    cout<<"Initialised"<<endl;
}

void printversion(void) {
    cout<<"Printing version."<<endl;
}

int magic_number(void) {
    return 2;
}

char *version = 2;

char *getversion(void) {
    return "The version is 2."
}

void deinitialise(void) {
    cout<<"Deinitialising. Goodbye world."<<endl;
}
}