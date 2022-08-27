.section .text
.global _start
    _start:

    mov x8, 64
    mov x0, 1
    ldr x1, =greet
    mov x2, 14
    svc 0

    mov x8, #0x5d
    mov x0, #0x0
    svc 0

.section .data
    greet:
        .ascii "Hello World!"

.section .bss
