# Write "Hello" to /tmp/hello
section .text
global _start
_start:

sub [string+5], "#"
sub [file+10], "#"

section .data
string db "Hello#"
file db "/tmp/hello#"
