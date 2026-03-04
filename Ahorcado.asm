section .data
    mensaje db 'Dime una letra:'
    longitud_1 equ $ - mensaje

    palabra db '______'
    longitud_2 equ $ - palabra

    salto db 0x0A

    solucion db 'MADRID'
    longitud_3 equ $ - solucion

section .bss
    letra resb 1
    espacio_restante resb 1

section .text
    global _start
_start:
    mov ecx, mensaje
    mov edx, longitud_1
    call print

    mov ecx, palabra
    mov edx, longitud_2
    call print

    mov ecx, salto
    mov edx, 1
    call print

    mov eax, 1
    mov ebx, 0
    int 0x80

print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret