section .text
global mystart                ; make the main function externally visible
mystart:
    push dword mylen          ; message length                           
    push dword mymsg          ; message to write
    push dword 1              ; file descriptor value
    mov eax, 0x4              ; system call number for write
    sub esp, 4                ; OS X (and BSD) system calls needs "extra space" on stack
    int 0x80                  ; make the actual system call
    add esp, 16               ; 3 args * 4 bytes/arg + 4 bytes extra space = 16 bytes
    push dword 0              ; exit status returned to the operating system
    mov eax, 0x1              ; system call number for exit
    sub esp, 4                ; OS X (and BSD) system calls needs "extra space" on stack
    int 0x80                  ; make the system call
section .data
  mymsg db "hello, world", 0xa  ; string with a carriage-return
  mylen equ $-mymsg             ; string length in bytes
