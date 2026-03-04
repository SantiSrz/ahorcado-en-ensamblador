section .data
    mensaje db 'Dime una letra:'
    longitud_1 equ $ - mensaje

    palabra db '______'
    longitud_2 equ $ - palabra

    solucion db 'MADRID'
    longitud_3 equ $ - solucion

    intentos db 'Numero de intentos restantes: '
    longitud_4 equ $ - intentos

    numero_contador db ' ', 0x0A
    longitud_5 equ $ - numero_contador

    salto db 0x0A

    vidas db 6

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

    mov al, byte [vidas]   
    add al, 48             
    mov [numero_contador], al

    mov ecx, salto
    mov edx, 1
    call print

    mov ecx, intentos
    mov edx, longitud_4
    call print

    mov ecx, numero_contador
    mov edx, longitud_5
    call print

    mov eax, 1
    mov ebx, 0
    int 0x80

print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret