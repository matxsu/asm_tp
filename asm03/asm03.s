section .data
    ok_msg db "1337", 10

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne .fail

    mov rsi, [rsp + 16]

    xor rcx, rcx
.strlen:
    cmp byte [rsi + rcx], 0
    je .check_len
    inc rcx
    jmp .strlen

.check_len:
    cmp rcx, 2
    jne .fail

    cmp byte [rsi],     '4'
    jne .fail
    cmp byte [rsi + 1], '2'
    jne .fail

    mov rax, 1
    mov rdi, 1
    mov rsi, ok_msg
    mov rdx, 5
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.fail:
    mov rax, 60
    mov rdi, 1
    syscall
