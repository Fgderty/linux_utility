section .text
global _start

_start:
;mkdir()
mov rax, 0x53
mov rdi, [rsp + 0x10]
mov rsi, 0x1FF
syscall

;exit()
mov rax, 0x3C
mov rdi, 0x00
syscall
