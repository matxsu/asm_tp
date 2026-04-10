section .bss
    outbuf resb 32

section .text
    global _start

atoi:
    xor rax, rax
.loop:
    movzx rbx, byte [rsi]
    cmp rbx, 0
    je .done
    sub rbx, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    ret

itoa:
    lea rdi, [outbuf + 30]
    mov byte [rdi], 10
    dec rdi
    xor rcx, rcx
    test rax, rax
    jnz .convert
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .done_itoa
.convert:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    inc rcx
    test rax, rax
    jnz .convert
.done_itoa:
    inc rdi
    mov rsi, rdi
    mov rdx, rcx
    inc rdx
    ret

_start:
    cmp qword [rsp], 3
    jne .fail

    mov rsi, [rsp + 16]
    call atoi
    mov r12, rax

    mov rsi, [rsp + 24]
    call atoi

    add rax, r12

    call itoa

    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.fail:
    mov rax, 60
    mov rdi, 1
    syscall
