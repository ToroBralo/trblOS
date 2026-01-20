; ------------------------------------------------------------
;  stage1.asm — Bootloader REAL (versión alfa)
; ------------------------------------------------------------
[org 0x7C00]
[bits 16]

BOOT_DRIVE db 0


start:
; -------------------------
; Inicializar segmentos
; -------------------------
    xor ax, ax
    mov ds, ax
    mov es, ax
    
; -----------------------------------------
; Cargar Stage2 desde disco
; -----------------------------------------
    mov [BOOT_DRIVE], dl
    mov bx, 0x1000        ; offset destino
    ; es ya está en 0x0000 (línea 15)

    mov ah, 0x02          ; INT 13h - leer sectores
    mov al, 4             ; número de sectores (Stage2)
    mov ch, 0x00          ; cilindro
    mov cl, 0x02          ; sector (empieza en 2 → LBA 1)
    mov dh, 0x00          ; cabeza
    mov dl, [BOOT_DRIVE]  ; disco desde BIOS

    int 0x13


; -------------------------
; Saltar a Stage2
; -------------------------
    jmp 0x0000:0x1000

; ============================================================
; FIRMA
; ============================================================

times 510-($-$$) db 0
dw 0xAA55
