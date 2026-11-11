section .text
global _start

_start:
;rmdir()
mov rax, 0x54
mov rdi, [rsp + 0x10]
syscall

;exit()
mov rax, 0x3C
mov rdi, 0x00
syscall
