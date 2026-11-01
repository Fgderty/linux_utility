section .bss
buffer resb 0x1000

section .text
global _start

_start:
;open_f()
mov rax, 0x02
mov rdi, [rsp + 0x10]
mov rsi, 0x00
mov rdx, 0x00
syscall
mov r12, rax

;open_s()
mov rax, 0x02
mov rdi, [rsp + 0x18]
mov rsi, 0x41
mov rdx, 0x1A4
syscall
mov r13, rax

.loop:
;read_f()
mov rax, 0x00
mov rdi, r12
mov rsi, buffer
mov rdx, 0x1000
syscall

cmp rax, 0x00
je .end

;write_s()
mov rdx, rax
mov rax, 0x01
mov rdi, r13 
mov rsi, buffer
syscall

jmp .loop

.end:
;close_f()
mov rax, 0x03
mov rdi, r12
syscall

;close_s()
mov rax, 0x03
mov rdi, r13
syscall

;exit()
mov rax, 0x3C
mov rdi, 0x00
syscall














