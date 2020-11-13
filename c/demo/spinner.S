	.file	"spinner.c"
	.comm	i,4,4
	.globl	spin
	.data
	.type	spin, @object
	.size	spin, 4
spin:
	.byte	124
	.byte	47
	.byte	45
	.byte	92
	.section	.rodata
.LC0:
	.string	"%s"
.LC1:
	.string	"Doing something..."
.LC2:
	.string	"\b\b %c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$.LC0, %eax
	movl	$.LC1, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$0, i(%rip)
.L2:
	movl	i(%rip), %eax
	addl	$1, %eax
	movl	%eax, i(%rip)
	movl	i(%rip), %eax
	movl	%eax, %edx
	sarl	$31, %edx
	shrl	$30, %edx
	addl	%edx, %eax
	andl	$3, %eax
	subl	%edx, %eax
	cltq
	movzbl	spin(%rax), %eax
	movsbl	%al, %edx
	movl	$.LC2, %eax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	movl	$50000, %edi
	movl	$0, %eax
	call	usleep
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	jmp	.L2
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.6.1-9ubuntu3) 4.6.1"
	.section	.note.GNU-stack,"",@progbits
