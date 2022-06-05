.globl _start
.align	2

_start:

init:
	nop
	li		sp, 2048	# 4096 (== 0x1000) for the code section plus another 1k for the data section
	j		main
