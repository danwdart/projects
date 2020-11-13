; runflat
section .text
global _start                ; make the main function externally visible
_start:
mov eax, 5 ;open
mov ebx, filename
mov edx, 0
int 80h ;now eax = fd
push eax ; save the returned fd in eax
mov eax, 3 ;read
pop ebx ; the fd is expected in b
mov ecx, buf
mov edx, 65535
int 80h
mov eax, 4 ;write
mov ebx, 0 ;fd 
mov ecx, buf
int 80h
mov eax, 1 ;exit
int 80h
section .data
filename db "/home/dan/projects/asm/unix/flat.bin", 0
buflab:
buf times 65535 db 0
