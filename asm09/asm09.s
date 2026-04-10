section .bss
    outbuf resb 72

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

to_hex:
    lea rdi, [outbuf + 68]
    mov byte [rdi], 10
    dec rdi
    xor rcx, rcx
    test rbx, rbx
    jnz .loop
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .done
.loop:
    test rbx, rbx
    jz .done
    mov rax, rbx
    and rax, 0xF
    cmp rax, 10
    jl .digit
    add rax, 'A' - 10
    jmp .store
.digit:
    add rax, '0'
.store:
    mov [rdi], al
    dec rdi
    inc rcx
    shr rbx, 4
    jmp .loop
.done:
    inc rdi
    mov rsi, rdi
    mov rdx, rcx
    inc rdx
    ret

to_bin:
    lea rdi, [outbuf + 68]
    mov byte [rdi], 10
    dec rdi
    xor rcx, rcx
    test rbx, rbx
    jnz .loop
    mov byte [rdi], '0'
    dec rdi
    inc rcx
    jmp .done
.loop:
    test rbx, rbx
    jz .done
    mov rax, rbx
    and rax, 1
    add rax, '0'
    mov [rdi], al
    dec rdi
    inc rcx
    shr rbx, 1
    jmp .loop
.done:
    inc rdi
    mov rsi, rdi
    mov rdx, rcx
    inc rdx
    ret

_start:
    mov r15, [rsp]
    cmp r15, 2
    jl .fail

    mov r14, [rsp + 16]

    cmp byte [r14],     '-'
    jne .hex_mode
    cmp byte [r14 + 1], 'b'
    jne .hex_mode

    cmp r15, 3
    jl .fail
    mov rsi, [rsp + 24]
    call atoi
    mov rbx, rax
    call to_bin
    jmp .write

.hex_mode:
    mov rsi, r14
    call atoi
    mov rbx, rax
    call to_hex

.write:
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
