GDT64:
    .Null: equ $ - GDT64         ; The null descriptor.
    ; This function need to be written by you.
 dw 0 ; Limit (low).
 dw 0 ; Base (low).
 db 0 ; Base (middle)
 db 0 ; Access byte.
 db 0 ; Flags - Limit(high).
 db 0 ; Base (high).

    .Code: equ $ - GDT64         ; The Kernel code descriptor.
    ; This function need to be written by you.
 dw 0 ; Limit (low).
 dw 0 ; Base (low).
 db 0 ; Base (middle)
 db 10011000b ; Access byte: Pr,ring0,Ex .
 db 00100000b ; Flags: L - Limit(high).
 db 0 ; Base (high).


    .Data: equ $ - GDT64         ; The Kernel data descriptor.
    ; This function need to be written by you.
 dw 0 ; Limit (low).
 dw 0 ; Base (low).
 db 0 ; Base (middle)
 db 10010011b ; Access byte: Pr,ring0,RW,Ac.
 db 00000000b ; Flags - Limit(high).
 db 0 ; Base (high).
ALIGN 4
 dw 0 ; Padding to make the "address of the GDT" field aligned on a 4-byte boundary

    .Pointer:
    ; This function need to be written by you.
 dw $ - GDT64 - 1 ; 16-bit Size (Limit) of GDT.
 dd GDT64 ; 32-bit Base Address of GDT. (CPU will zero extend to 64-bit)
lgdt [GDT64.Pointer] ; Load GDT.Pointer defined below.
jmp CODE_SEG:LM64 ; Load CS with 64 bit GDT segment and flush the instruction cache
;*********************************** Long Mode 64-bit **********************************
[BITS 64]
LM64:
 mov ax, DATA_SEG ; Set data segment to GDT Data Segment selector
 mov ds, ax
 mov es, ax
 mov fs, ax
 mov gs, ax
 jmp 0x10000 ; Jump to Third Stage boot loader
lm_hang: ; Halt Loop
 hlt
 jmp lm_hang
times 4096-($-$$) db 0
