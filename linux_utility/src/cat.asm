section .bss
buffer resb 0x1000

section .text
global _start

_start:

;open()
mov rax, 0x02
mov rdi, [rsp + 0x10]
mov rsi, 0x00
mov rdx, 0x00
syscall
mov r8, rax

;read()
mov rax, 0x00
mov rdi, r8
mov rsi, buffer
mov rdx, 0x1000
syscall

;write()
mov rdx, rax
mov rax, 0x01
mov rdi, 0x01
mov rsi, buffer
syscall

;close()
mov rax, 0x03
mov rdi, r8
syscall

;exit()
mov rax, 0x3C
mov rdi, 0x00
syscall
