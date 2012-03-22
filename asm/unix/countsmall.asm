section .text
global _start
_start:
mov cx, 200
rep
jmp .write

mov ax, 0
int 80h

.write:
mov ax, 2
mov 
ret

section .data
