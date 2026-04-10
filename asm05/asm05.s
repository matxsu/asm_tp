section .data
    nl db 10

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jl .exit_ok

    mov rdi, [rsp + 16]

    xor rdx, rdx
.strlen:
    cmp byte [rdi + rdx], 0
    je .do_write
    inc rdx
    jmp .strlen

.do_write:
    cmp rdx, 0
    je .exit_ok

    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

.exit_ok:
    mov rax, 60
    xor rdi, rdi
    syscall
