extern _start;
void kmain() {
    char *addr = (char *)0xb8000;
    addr[0] = 0x41;
}
