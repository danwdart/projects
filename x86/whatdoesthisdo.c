#include <stdio.h>
#include <string.h>

unsigned const char code[] = "\x0f\x0d\x00\xc3";

int main() {
    int (*ret)() = (int(*)())code;
    ret();
}