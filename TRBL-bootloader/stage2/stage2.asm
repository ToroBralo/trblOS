; ------------------------------------------------------------
; STAGE2
; ------------------------------------------------------------
[org 0x1000]
[bits 16]

start:
cli
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00

; DEBUG: R
mov ax, 0xB800
mov es, ax
mov word [es:0], 0x1F52 ; "R"

call enable_a20
lgdt [gdt_descriptor]

mov eax, cr0
or eax, 1
mov cr0, eax

; FAR JUMP A PM
db 0x66
db 0xEA
dd 0x1200
dw 0x08

; ----------------------------
enable_a20:
in al, 0x92
or al, 2
out 0x92, al
ret

; ----------------------------
; GDT
gdt_start:
dq 0

gdt_code:
dw 0xFFFF
dw 0
db 0
db 10011010b
db 11001111b
db 0

gdt_data:
dw 0xFFFF
dw 0
db 0
db 10010010b
db 11001111b
db 0

gdt_end:

gdt_descriptor:
dw gdt_end - gdt_start - 1
dd gdt_start

times 512-($-$$) db 0
