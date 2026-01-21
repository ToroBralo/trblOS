; ------------------------------------------------------------
; STAGE2 PROTECTED MODE
; ------------------------------------------------------------
[org 0x1200]
[bits 32]

global protected_mode_entry

protected_mode_entry:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000

    mov dword [0xB8000], 0x1F321F33 ; "32"
    mov dword [0xB8004], 0x1F4B1F4F ; "OK"

.hang:
    hlt
    jmp .hang



times 512 - ($ - $$) db 0




