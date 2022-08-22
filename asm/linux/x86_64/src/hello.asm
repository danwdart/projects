section .data
    greet db "Hello World!"
    greet_end db 0
section .bss
section .text
    global _start
    _start:

    mov rax, 1 ; write
    mov rdi, 1 ; stdout
    mov rsi, greet
    mov rdx, greet_end - greet
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
