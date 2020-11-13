# Write "Hello" to /tmp/hello
section .text
global _start
_start:
mov si, string
mov di, file
add si, 5
add di, 10

sub [si], 0x23
sub [di], 0x23

section .data
string db "Hello#"
file db "/tmp/hello#"
