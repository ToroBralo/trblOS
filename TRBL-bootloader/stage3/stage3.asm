; ----------------------------
; STAGE3
; ----------------------------
[org 0x1200]
[bits 32]

KERNEL_CS equ 0x08
KERNEL_DS equ 0x10
IDT_ENTRIES equ 256

global protected_mode_entry

; ================================
; ENTRY PM
; ================================
protected_mode_entry:

cli

; Segments
mov ax, KERNEL_DS
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

; Stack SAFE (NO .bss pointer)
mov esp, 0x9FC00

; DEBUG: "PM OK"
mov dword [0xB8000], 0x1F4D1F50 ; PM
mov dword [0xB8004], 0x1F4F1F4B ; OK

; Init IDT
call idt_init
call idt_load

sti ; Now safe to enable interrupts
xor eax, eax
div eax ; Provoca #DE para probar el manejador
.loop:
hlt
jmp .loop

; ================================
; IDT TABLE
; ================================
section .data

idt_start:
times IDT_ENTRIES dq 0
idt_end:

idt_descriptor:
dw idt_end - idt_start - 1
dd idt_start

; ================================
; LOAD IDT
; ================================
section .text

idt_load:
lidt [idt_descriptor]
ret

; ================================
; SET IDT GATE
; eax = vector
; ebx = handler
; ================================
idt_set_gate:
push edx
push ecx

mov edx, ebx
mov ecx, eax
shl ecx, 3
add ecx, idt_start

mov word [ecx], dx
mov word [ecx + 2], KERNEL_CS
mov byte [ecx + 4], 0
mov byte [ecx + 5], 10001110b ; present, ring0, int gate
shr edx, 16
mov word [ecx + 6], dx

pop ecx
pop edx
ret

; ================================
; GENERIC EXCEPTION HANDLER
; ================================
isr_stub:
cli
pushad
; VGA directo sin segmentos
mov byte [0xB8008], 'E'
mov byte [0xB8009], 0x4F
mov byte [0xB800A], 'X'
mov byte [0xB800B], 0x4F

popad
iret




; ================================
; INIT ALL CPU EXCEPTIONS (0–31)
; ================================
idt_init:
push eax
push ebx

xor eax, eax
mov ebx, isr_stub

.exc_loop:
cmp eax, 32
je .done

call idt_set_gate
inc eax
jmp .exc_loop

.done:
pop ebx
pop eax
ret
