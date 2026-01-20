; STAGE2 REAL MODE - MINIMAL SKELETON

[org 0x1000]
[bits 16]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; DEBUG: mensaje simple
    mov si, msg_real
    call print

    ; (aquí NO entramos aún en PM)
    jmp $

print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

msg_real db "Stage2 REAL OK", 0











