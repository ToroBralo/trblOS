; ------------------------------------------------------------
; STAGE2 REAL MODE - MINIMAL & SAFE
; ------------------------------------------------------------

[org 0x1000]
[bits 16]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov sp, 0x7C00  ; Stack temporal seguro

    call enable_a20

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Far jump obligatorio para limpiar la cola
    db 0x66        ; operand-size override (CRÍTICO)
    db 0xEA        ; opcode JMP FAR
    dd 0x1200      ; offset 32 bits
    dw 0x08        ; selector de código


; ------------------------------------------------------------
; A20 (Fast Gate)
; ------------------------------------------------------------

enable_a20:
    in al, 0x92
    or al, 00000010b
    out 0x92, al
    ret

; ------------------------------------------------------------
; GDT
; ------------------------------------------------------------

gdt_start:
    dq 0x0000000000000000

gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start



times 512 - ($ - $$) db 0






