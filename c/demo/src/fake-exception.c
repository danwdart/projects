#include <stdio.h>
/*
int setjmp(jmp_buf env);
void longjmp(jmp_buf env, int val);
*/
#include <setjmp.h>

jmp_buf my_buffer;

void do_something(int argc) {
    if (argc > 2) {
        printf("Throw 1!\n");
        longjmp(my_buffer, 1);
    }
    printf("All is fine\n");
}

void demo1(int argc) {
    printf("Scanning for code.\n");

    int code = setjmp(my_buffer);

    printf("Code is %d\n");

    switch (code) {
        case 0:
            printf("Before throw.\n");
            do_something(argc);
            printf("After maybe throw.\n");
            break;

        case 1:
            printf("Catch 1\n");
            break;
    }

    printf("After all\n");
}

int main(int argc, char **argv) {
    demo1(argc);

    return 0;
}