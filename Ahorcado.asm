section .data
    mensaje db 'Dime una letra: '
    longitud_1 equ $ - mensaje
    palabra db '______', 0x0A
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
    basura resb 1

section .text
    global _start

_start:

game_loop:
    mov ecx, palabra
    mov edx, longitud_2
    call print

    mov ecx, intentos
    mov edx, longitud_4
    call print

    mov al, byte [vidas]
    add al, 48
    mov [numero_contador], al
    mov ecx, numero_contador
    mov edx, longitud_5
    call print

    mov ecx, mensaje
    mov edx, longitud_1
    call print

    mov eax, 3
    mov ebx, 0
    mov ecx, letra
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

    mov esi, solucion
    mov edi, palabra
    mov ecx, longitud_3
    mov bl, 0

bucle_comparacion:
    mov al, byte [esi]
    cmp al, byte [letra]
    jne no_coincide
    mov byte [edi], al
    mov bl, 1
no_coincide:
    inc esi
    inc edi
    loop bucle_comparacion

    cmp bl, 0
    jne verificar_fin
    dec byte [vidas]
    jz fin

verificar_fin:
    mov ecx, longitud_3
    mov edi, palabra
    mov al, '_'
    xor edx, edx
revisar_guiones:
    cmp byte [edi], al
    jne letra_revelada
    inc edx
letra_revelada:
    inc edi
    loop revisar_guiones

    cmp edx, 0
    je fin
    jmp game_loop

fin:
    mov ecx, palabra
    mov edx, longitud_2
    call print
    mov eax, 1
    xor ebx, ebx
    int 0x80

print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret