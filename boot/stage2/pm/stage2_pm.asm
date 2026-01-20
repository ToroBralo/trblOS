; STAGE2 PROTECTED MODE - PLACEHOLDER

[bits 32]

protected_mode_entry:
    mov dword [0xB8000], 0x1F501F50 ; "PP"
.hang:
    hlt
    jmp .hang










