section .text
    global _start
    _start:

    mov rax, 1 ; write
    mov rdi, 1 ; stdout
    mov rsi, greet
    mov rdx, greet_len
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
section .data
    greet db "Hello World!" ; hmm interesting no \n
    greet_len equ $ - greet
section .bss