section .text
global _start

_start:
;unlink()
mov rax, 0x57
mov rdi, [rsp + 0x10]
syscall

;exit()
mov rax, 0x3C
mov rdi, 0x00
syscall
