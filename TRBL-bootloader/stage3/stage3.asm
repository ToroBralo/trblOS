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
call pic_remap
call pit_init

mov eax, 32       ; IRQ0 = vector 32
mov ebx, irq0_handler
call idt_set_gate


sti ; Now safe to enable interrupts

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


pic_remap:
mov al, 0x11
out 0x20, al
out 0xA0, al

mov al, 0x20
out 0x21, al
mov al, 0x28
out 0xA1, al

mov al, 0x04
out 0x21, al
mov al, 0x02
out 0xA1, al

mov al, 0x01
out 0x21, al
out 0xA1, al

; solo IRQ0 activada
mov al, 11111110b
out 0x21, al
mov al, 11111111b
out 0xA1, al

ret

irq0_handler:
pushad

inc dword [tick_count]

mov eax, [tick_count]
add eax, '0'
mov byte [0xB800E], al
mov byte [0xB800F], 0x0A

mov al, 0x20
out 0x20, al

popad
iret


pit_init:
mov al, 00110110b   ; Channel 0, lobyte/hibyte, mode 3
out 0x43, al

mov ax, 1193182 / 100  ; ~100 Hz
out 0x40, al
mov al, ah
out 0x40, al

ret

section .bss
tick_count resd 1