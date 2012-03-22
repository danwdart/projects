section .text
global _start
_start:
mov ax, 2
int 80h
jmp _start
section .data
