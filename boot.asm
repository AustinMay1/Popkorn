global start

section .text
bits 32
start:
    mov eax, p3_table
    or eax, 0b11
    mov dword [p4_table + 0], eax
    
    mov eax, p2_table
    or eax, 0b11
    mov dword [p3_table + 0], eax

    mov ecx, 0                              ; initialize loop counter
    .map_p2_table:                          ; loop label
        mov eax, 0x200000                   ; store 2,097,152 in reg eax
        mul ecx                             ; multiply eax by counter
        or eax, 0b10000011                  ; set 'huge page bit'
        mov [p2_table + ecx * 8], eax       ; write val of eax to p2_table * 8 
        inc ecx                             ; increment counter
        cmp ecx, 512                        ; compare counter to 512 (# of pages)
        jne .map_p2_table                   ; restart loop if counter != 512

    mov eax, p4_table                       ; put p4_table into eax
    mov cr3, eax                            ; move eax into cr3 (control reg)

    mov eax, cr4                            ; move value of cr4 to eax
    or eax, 1 << 5                          ; left shift eax 2^5 = 100000
    mov cr4, eax                            ; enable PAE

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr                                   ; setting the long bit

    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax                            ; enable paging

    lgdt [gdt64.pointer]                    ; load global desc table

    mov ax, gdt64.data
    mov ss, ax
    mov ds, ax
    mov es, ax

    jmp gdt64.code:long_mode_start

    mov word [0xb8000], 0x0348              ; 'H'
    mov word [0xb8002], 0x0365              ; 'e'
    mov word [0xb8004], 0x036C              ; 'l'
    mov word [0xb8008], 0x036C              ; 'l'
    mov word [0xb800A], 0x036F              ; 'o'
    mov word [0xb800C], 0x0320              ; ' '
    mov word [0xb800E], 0x0377              ; 'w'
    mov word [0xb8010], 0x036F              ; 'o'
    mov word [0xb8012], 0x0372              ; 'r'
    mov word [0xb8014], 0x036C              ; 'l'
    mov word [0xb8016], 0x0364              ; 'd'
    mov word [0xb8018], 0x0321              ; '!'
    hlt

section .bss
align 4096
p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096

section .rodata
gdt64:
    dq 0

.code: equ $ - gdt64
    dq (1 << 44) | (1 << 47) | (1 << 41) | (1 << 43) | (1 << 53)

.data: equ $ - gdt64
    dq (1 << 44) | (1 << 47) | (1 << 41)

.pointer:
    dw .pointer - gdt64 - 1
    dq gdt64

section .text
bits 64
long_mode_start:
    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xb8000], rax

    hlt
