%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define SYS_EXIT 60
%define SYS_GETDENTS64 217

%define O_RDONLY 0
%define O_DIRECTORY 0o200000

%define STDOUT 1
%define STDERR 2

%define DIRBUF_SIZE 32768
%define OUTBUF_SIZE 8192

; struct linux_dirent64: d_ino +0, d_off +8, d_reclen +16, d_type +18, d_name +19
%define D_RECLEN 16
%define D_NAME 19

section .data
    dot db ".", 0
    err_open db "ls: cannot open directory", 10
    err_open_l equ $ - err_open
    err_read db "ls: error reading directory", 10
    err_read_l equ $ - err_read

section .bss
    dirbuf resb DIRBUF_SIZE
    outbuf resb OUTBUF_SIZE
    outpos resq 1
    show_all resb 1

section .text
global _start

_start:
    ; [rsp]=argc, [rsp+8]=argv[0], [rsp+16]=argv[1], ...
    mov rbx, [rsp]
    lea r12, [rsp + 16]
    lea rdi, [rel dot] ; путь по умолчанию
    dec rbx

.parse_args:
    test rbx, rbx
    jz .open_dir
    mov rsi, [r12]
    cmp byte [rsi], '-' ; это "-a"?
    jne .path_arg
    cmp byte [rsi + 1], 'a'
    jne .path_arg
    cmp byte [rsi + 2], 0
    jne .path_arg
    mov byte [rel show_all], 1
    jmp .next_arg
.path_arg:
    mov rdi, rsi
.next_arg:
    add r12, 8
    dec rbx
    jmp .parse_args

.open_dir:
    mov eax, SYS_OPEN ; open(path, O_RDONLY|O_DIRECTORY)
    mov esi, O_RDONLY | O_DIRECTORY
    xor edx, edx
    syscall
    test rax, rax
    js .fail_open
    mov r13, rax ; r13 = fd

.read_loop:
    mov eax, SYS_GETDENTS64 ; getdents64(fd, dirbuf, size)
    mov rdi, r13
    lea rsi, [rel dirbuf]
    mov edx, DIRBUF_SIZE
    syscall
    test rax, rax
    js .fail_read
    jz .done ; 0 — записи кончились

    lea r14, [rel dirbuf] ; текущая запись
    lea r15, [r14 + rax] ; конец данных

.entry_loop:
    cmp r14, r15
    jae .read_loop
    lea rsi, [r14 + D_NAME]
    cmp byte [rel show_all], 0 ; без -a пропускаем дотфайлы
    jne .print_it
    cmp byte [rsi], '.'
    je .skip
.print_it:
    call emit_cstr
    mov al, 10
    call emit_byte
.skip:
    movzx eax, word [r14 + D_RECLEN]
    add r14, rax
    jmp .entry_loop

.done:
    call flush
    mov eax, SYS_CLOSE
    mov rdi, r13
    syscall
    xor edi, edi
    jmp exit

.fail_open:
    lea rsi, [rel err_open]
    mov edx, err_open_l
    jmp .fail
.fail_read:
    call flush
    lea rsi, [rel err_read]
    mov edx, err_read_l
.fail:
    mov eax, SYS_WRITE
    mov edi, STDERR
    syscall
    mov edi, 1
exit:
    mov eax, SYS_EXIT
    syscall

; emit_cstr: rsi = строка с нулём на конце -> в буфер
emit_cstr:
.loop:
    mov al, [rsi]
    test al, al
    jz .ret
    push rsi
    call emit_byte
    pop rsi
    inc rsi
    jmp .loop
.ret:
    ret

; emit_byte: al -> в буфер, сброс при заполнении
emit_byte:
    mov rcx, [rel outpos]
    lea rdx, [rel outbuf]
    mov [rdx + rcx], al
    inc rcx
    mov [rel outpos], rcx
    cmp rcx, OUTBUF_SIZE
    jb .ret
    call flush
.ret:
    ret

; flush: буфер -> stdout, с дозаписью при short write
flush:
    push rsi
    lea rsi, [rel outbuf]
    mov rdx, [rel outpos]
.again:
    test rdx, rdx
    jz .out
    mov eax, SYS_WRITE
    mov edi, STDOUT
    push rdx
    push rsi
    syscall
    pop rsi
    pop rdx
    test rax, rax
    jle .out
    add rsi, rax
    sub rdx, rax
    jmp .again
.out:
    mov qword [rel outpos], 0
    pop rsi
    ret
