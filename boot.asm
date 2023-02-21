%include "16bit_color_vga.asm"
section .boot
bits 16; such as use 16 in yasm
global boot

boot:
    mov ax, 0x2401; set to register ax to work int 0x15. 2401 becouse it is number of instrcution
    int 0x15; get a table e820 that display information about adress space
    mov ax, 0x3; need to call video memory (cursor)
    int 0x10; call video service
; now we need to get more than 512 bytes to load. To achive this we call int 0x13, that can read memory pointer
    mov [disk], dl
    mov ah, 0x2 ; read sectors
    mov al, 6 ; count sectors
    mov ch, 0 ; read cylinder with 0 idx
    mov dh, 0 ; read head idx
    mov cl, 2 ; read third sector (with idx = 2)
    mov dl, [disk] ; disk idx (C, D or anything another)
    mov bx, boot_more ; target pointer load to bx
    int 0x13 ; int that read need part
    cli
    lgdt [gdt_pointer]; Load Global Data Table

; Now we need to enter safety mode to get 16 megabytes of memory;

    mov eax, cr0; cr0 is control register 0, tha consist need flags;
    or eax, 0x1; set the protected mode bit on reg cr0; first bit;
    mov cr0, eax; clear eax;
; Now we need to update all regs
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp CODE_SEG:boot_2; long jump to code segment
%include "gdt.asm"
disk:
    db 0x0
times 510 - ($-$$) db 0 ; remainin 510 bytes wtih zeros
dw 0xaa55; mark this 512 byte bootable


; ----------------- THIS PART AFTER 512 BYTES -------------------------


boot_more:

bits 32 

hello: db "I am from 512 bytes after!", 0

boot_2:
     mov esi, hello
     mov ebx, 0xb8000
.loop:
    lodsb ; load from memory allocator from register ESI, becouse now we 32 bits;
    or al, al ; logical or and result will be write to al (if al == 0)
    jz halt; jump to function halt if al == 0;
    ;or eax, 0x0100 ; set third bit to 1. Need to set blue;
    or eax, BLACK_FOREGROUND_COLOR; for example this set a green. first 8 bits need to setbackground and foreground color;
    or eax, WHITE_BACKGROUND_COLOR;    
;or eax, 0x1000 - this sets a background color
    mov word [ebx], ax ; write to ax word in ebx
    add ebx, 2 ; add to ebx 2
    jmp .loop

halt:
    mov esp, kernel_stack_top
    extern main
    call main
    cli; clear interrupt flag
    hlt;  halt execution (stop)

section .bss 
kernel_stack_bottom: equ $
resb 16384 ; 16 KB
kernel_stack_top:
