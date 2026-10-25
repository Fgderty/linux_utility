section .text
global _start

_start:
;open()
mov rax, 0x02
mov rdi, [rsp + 0x10]
mov rsi, 0x41
mov rdx, 0x1A4
syscall

;exit()
mov rax, 0x3C
mov rdi, 0x00
syscall
