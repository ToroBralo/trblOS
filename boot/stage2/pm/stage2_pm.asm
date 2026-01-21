; ------------------------------------------------------------
; STAGE2 PROTECTED MODE
; ------------------------------------------------------------
[org 0x1200]     ; EXACTAMENTE donde está cargado
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


[BITS 32]

; ==============================
; Constantes
; ==============================
IDT_ENTRIES equ 256
KERNEL_CS   equ 0x08        ; Selector de código (GDT)

; ==============================
; IDT
; ==============================
section .data

idt_start:
    times IDT_ENTRIES dq 0
idt_end:

idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

; ==============================
; Código
; ==============================
section .text
global idt_load
global isr0

; ------------------------------
; Cargar IDT
; ------------------------------
idt_load:
    lidt [idt_descriptor]
    ret

; ------------------------------
; ISR ejemplo (Divide by Zero)
; ------------------------------
isr0:
    cli
    pushad

    ; Aquí iría tu lógica de manejo
    ; (debug, imprimir, halt, etc.)

    popad
    sti
    iret

; ------------------------------
; Inicializar una entrada IDT
; ------------------------------
global idt_set_gate
idt_set_gate:
    ; void idt_set_gate(int n, uint32 handler)
    ; eax = n
    ; ebx = handler

    mov edx, ebx
    mov ebx, eax
    shl ebx, 3
    add ebx, idt_start

    mov word [ebx], dx          ; offset low
    mov word [ebx + 2], KERNEL_CS
    mov byte [ebx + 4], 0
    mov byte [ebx + 5], 10001110b ; Present, Ring 0, 32-bit interrupt gate
    shr edx, 16
    mov word [ebx + 6], dx      ; offset high

    ret
