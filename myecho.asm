section .rodata
space db " ", 0x00
newline db 0x0A, 0x00

section .text
global _start

_start:
lea r14, [rsp + 0x10]
mov r13, [r14]
test r13, r13
jz .args_end

mov rdi, r13
call len

;write()
mov rdx, rax
mov rax, 0x01
mov rdi, 0x01
mov rsi, r13
syscall

add r14, 0x08

.output:
mov r13, [r14]
test r13, r13
jz .args_end

;write()
mov rax, 0x01
mov rdi, 0x01
mov rsi, space
mov rdx, 0x01
syscall

mov rdi, r13
call len

;write()
mov rdx, rax
mov rax, 0x01
mov rdi, 0x01
mov rsi, r13
syscall

add r14, 0x08
jmp .output

.args_end:
;write()
mov rax, 0x01
mov rdi, 0x01
mov rsi, newline
mov rdx, 0x01
syscall

;exit()
mov rax, 0x3C
mov rdi, 0x00
syscall

len:
push rbp
mov rbp, rsp

mov rsi, rdi
xor edx, edx
jmp .loop

.loop:
cmp byte [rsi], 0x00
je .end
inc edx
inc rsi
jmp .loop

.end:
mov rax, rdx
mov rsp, rbp
pop rbp
ret
