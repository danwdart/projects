section .text
global _start
_start:
mov eax, 3
mov ebx, 1
mov ecx, buf
mov edx, 1
int 80h
add byte [buf],1
mov eax, 4
mov ebx, 0
mov ecx, buf
mov edx, 1
int 80h
jmp _start
section .data
buf times 64 db 0
