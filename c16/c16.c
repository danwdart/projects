__asm__(".code16gcc\n");
__asm__("jmpl $0, $main\n");
main() {
int a;
asm("mov 0x41, %al\nmov 0x0e, %ah\nint $10");
}
