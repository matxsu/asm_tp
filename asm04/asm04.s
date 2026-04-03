DEFAULT REL
section .bss
    buf resb 32

section .text
    global _start

_start:
    cmp qword [rsp], 1
    jne .no_stdin

    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 32
    syscall
    cmp rax, 0
    jle .fail

    lea rsi, [buf]
    xor rbx, rbx
.parse:
    movzx rax, byte [rsi]
    cmp al, 10
    je .parsed
    cmp al, 0
    je .parsed
    sub al, '0'
    imul rbx, 10
    add rbx, rax
    inc rsi
    jmp .parse

.parsed:
    test rbx, 1
    jz .even
    mov rax, 60
    mov rdi, 1
    syscall
.even:
    mov rax, 60
    xor rdi, rdi
    syscall

.no_stdin:
    mov rax, 60
    mov rdi, 2
    syscall

.fail:
    mov rax, 60
    mov rdi, 1
    syscall
