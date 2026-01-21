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

    call init_idt


    mov dword [0xB8000], 0x1F321F33 ; "32"
    mov dword [0xB8004], 0x1F4B1F4F ; "OK"

.hang:
    hlt
    jmp .hang


; ============================================================
; ISR STUB (handler seguro)
; ============================================================
isr_stub:
    mov dword [0xB8000], 0x4F584F45 ; "EX"
.isr_hang:
    hlt
    jmp .isr_hang

; ============================================================
; IDT TABLE
; ============================================================
align 8
idt_start:
    times 256 dq 0
idt_end:

idt_descriptor:
    dw idt_end - idt_start - 1
    dd idt_start

; ============================================================
; INIT IDT
; ============================================================
init_idt:
    mov edi, idt_start
    mov ecx, 256

.fill:
    mov eax, isr_stub

    ; offset low
    mov word [edi + 0], ax

    ; selector de código
    mov word [edi + 2], 0x08

    ; byte cero
    mov byte [edi + 4], 0

    ; flags: present | ring0 | interrupt gate
    mov byte [edi + 5], 0x8E

    ; offset high
    shr eax, 16
    mov word [edi + 6], ax

    add edi, 8
    loop .fill

    lidt [idt_descriptor]
    ret

