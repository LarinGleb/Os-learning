
gdt_start:

; a null segment. Skip first bytes;
gdt_null: 
	dd 0x0
	dd 0x0

; comment only for this segment: code segmemt
gdt_cs:
	dw 0xFFFF ; limit for max segment size
	dw 0x0000  ; linear adress where the segment begin
	db 0x0000 ; copy of previous
	db 10011011b ; accsess byte;
; present bit = 1
; DPL = 00  privilege level, 00 = highest level;
; S = 1, defines a code or data segment;
; E = 1, defines it a code segment;
; DC = 0 direction bit is 0 now;
; RW = 1 access to write to it bit;
;A  = 1 set the segment is accessed;

; now we describe a limit and flags;
	db 11011111b
;we need only a 1101 value;
; Granilarity flag = 1. Neew to increase a limit
; DB = 1, need to define a 32-bit protect mode
; Long mode, 0 because we in 32 bit;
; 1 is reversed for 0

; a copy of base segment
	db 0x0000

; analogy of code segment, only change executable bit;
gdt_ds:
	dw 0xFFFF    
	dw 0x0000   
	db 0x0000
	db 10010011b
	db 11011111b
	db 0x0000

gdt_end:    

gdt_pointer:
	dw gdt_end - gdt_start - 1 ; GDT size
	dd gdt_start

CODE_SEG equ gdt_cs - gdt_start
DATA_SEG equ gdt_ds - gdt_start
