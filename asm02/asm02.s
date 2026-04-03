DEFAULT REL
section .data
    ok_msg  db "1337", 10

section .bss
    buf     resb 16

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 16
    syscall

    cmp rax, 3
    jne .fail

    cmp byte [buf],     '4'
    jne .fail
    cmp byte [buf + 1], '2'
    jne .fail
    mov al, [buf + 2]
    cmp al, 10
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