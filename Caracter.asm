section .data
    mensaje db 'Introduce una letra: '
    longitud equ $ - mensaje

section .bss
    caracter resb 1 
    basura  resb 1

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, mensaje
    mov edx, longitud
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, caracter
    mov edx, 1
    int 0x80
    
limpiar_buffer:
    mov eax, 3
    mov ebx, 0
    mov ecx, basura
    mov edx, 1
    int 0x80

    mov al, byte [basura]
    cmp al, 0x0A
    jne limpiar_buffer

    mov eax, 1
    mov ebx, 0
    int 0x80