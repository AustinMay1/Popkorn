global start

section .text
bits 32
start:
    mov word [0xb8000], 0x0348      ; 'H'
    mov word [0xb8002], 0x0365      ; 'e'
    mov word [0xb8004], 0x036C      ; 'l'
    mov word [0xb8008], 0x036C      ; 'l'
    mov word [0xb800A], 0x036F      ; 'o'
    mov word [0xb800C], 0x0320      ; ' '
    mov word [0xb800E], 0x0377      ; 'w'
    mov word [0xb8010], 0x036F      ; 'o'
    mov word [0xb8012], 0x0372      ; 'r'
    mov word [0xb8014], 0x036C      ; 'l'
    mov word [0xb8016], 0x0364      ; 'd'
    mov word [0xb8018], 0x0321      ; '!'
    hlt
