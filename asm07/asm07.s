section .bss
    buf resb 32
section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 32
    syscall

    lea rsi, [buf]
    xor rbx, rbx
.parse:
    movzx rax, byte [rsi]
    cmp al, 10
    je .check
    cmp al, 0
    je .check
    sub al, '0'
    imul rbx, 10
    add rbx, rax
    inc rsi
    jmp .parse

.check:
    cmp rbx, 2
    jl .not_prime
    je .prime
    test rbx, 1
    jz .not_prime
    mov rcx, 3
    mov rax, rcx
    mul rcx
    cmp rax, rbx
    jg .prime

    mov rax, rbx
    xor rdx, rdx
    div rcx
    test rdx, rdx
    jz .not_prime

    add rcx, 2
    jmp .trial

.prime:
    mov rax, 60
    xor rdi, rdi
    syscall

.not_prime:
    mov rax, 60
    mov rdi, 1
    syscall
