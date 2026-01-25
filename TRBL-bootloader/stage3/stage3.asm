; ----------------------------
; STAGE3
; ----------------------------
[org 0x1200]
[bits 32]

KERNEL_DS equ 0x10

protected_mode_entry:

cli

; segmentos OK
mov ax, KERNEL_DS
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

; stack segura
mov esp, 0x9FC00

; DEBUG VISUAL: escribe "PM KO"
mov dword [0xB8000], 0x1F4D1F50 ; PM
mov dword [0xB8008], 0x1F4F1F4B ; KO

; 🔴 NO STI
.loop:
hlt
jmp .loop
