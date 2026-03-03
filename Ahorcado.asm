section .data

    mensaje db 'Hola Mundo'
    longitud equ $ - mensaje

section .text

    global _start
_start:

    mov eax, 4
    mov ebx, 1
    call print

    mov eax, 1
    mov ebx, 0

    int 0x80

print:
    mov ecx, mensaje
    mov edx, longitud
    int 0x80
    ret