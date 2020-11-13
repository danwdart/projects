;cpuid
section .text
global _start
_start:
mov eax, 0 ; vendor id
cpuid
push ecx
push edx
push ebx
mov eax, 4 ;write
mov ebx, 0 ;stdout
mov ecx, esp ;loc
mov edx, 12 ; count
int 80h
mov ecx, end
mov edx, 2
mov eax, 4
int 80h
mov eax, 1 ;exit
int 80h
section .data
end db 0d0ah
