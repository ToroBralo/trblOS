; ------------------------------------------------------------
; stage1.asm — Bootloader REAL (FIXED)
; ------------------------------------------------------------
[org 0x7C00]
[bits 16]

BOOT_DRIVE db 0

start:
cli

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00        ; PILA (CRÍTICO)

sti

mov [BOOT_DRIVE], dl

; ------------------------------------------------------------
; Cargar Stage2 (2 sectores)
; ------------------------------------------------------------
mov ax, 0x0000
mov es, ax
mov bx, 0x1000        ; destino

mov ah, 0x02          ; INT 13h - leer
mov al, 2             ; <<< SOLO 2 SECTORES
mov ch, 0x00
mov cl, 0x02          ; sector 2
mov dh, 0x00
mov dl, [BOOT_DRIVE]

int 0x13
jc disk_error

jmp 0x0000:0x1000

disk_error:
hlt
jmp disk_error

times 510-($-$$) db 0
dw 0xAA55
