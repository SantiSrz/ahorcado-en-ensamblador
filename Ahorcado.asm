section .data
    mensaje db 'Dime una letra: '
    longitud_1 equ $ - mensaje

    intentos db 'Numero de intentos restantes: '
    longitud_4 equ $ - intentos

    numero_contador db ' ', 0x0A
    longitud_5 equ $ - numero_contador

    salto db 0x0A
    vidas_iniciales db 6

    msj_victoria db 'Enhorabuena, has adivinado la palabra.', 0x0A
    longitud_6 equ $ - msj_victoria

    msj_derrota db 'Lo siento, no has logrado adivinar la palabra.', 0x0A
    longitud_7 equ $ - msj_derrota

    banco   db 'MADRID', 0, 0, 0, 0
            db 'CPU', 0, 0, 0, 0, 0, 0, 0
            db 'LINUX', 0, 0, 0, 0, 0
            db 'MEMORIA', 0, 0, 0
            db 'TECLADO', 0, 0, 0
    
    num_palabras equ 5
    tamano_bloque equ 10

section .bss
    letra resb 1
    basura resb 1
    vidas resb 1
    palabra_secreta resd 1
    longitud_palabra resb 1
    tablero resb 10

section .text
    global _start

_start:
    mov al, byte [vidas_iniciales]
    mov byte [vidas], al

    mov eax, 13
    xor ebx, ebx
    int 0x80

    xor edx, edx
    mov ecx, num_palabras
    div ecx

    mov eax, edx
    mov ecx, tamano_bloque
    mul ecx
    mov esi, banco
    add esi, eax
    mov [palabra_secreta], esi

    mov edi, tablero
    xor ecx, ecx

medir_palabra:
    mov al, byte [esi + ecx]
    cmp al, 0
    je fin_medir
    mov byte [edi + ecx], '_'
    inc ecx
    jmp medir_palabra

fin_medir:
    mov byte [longitud_palabra], cl

game_loop:
    mov ecx, tablero
    movzx edx, byte [longitud_palabra]
    call print
    
    mov ecx, salto
    mov edx, 1
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

    call a_mayuscula

    mov esi, [palabra_secreta]
    mov edi, tablero
    movzx ecx, byte [longitud_palabra]
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
    jz derrota

verificar_fin:
    movzx ecx, byte [longitud_palabra]
    mov edi, tablero
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
    je victoria
    jmp game_loop

fin:
    mov eax, 1
    xor ebx, ebx
    int 0x80

a_mayuscula:
    mov al, byte [letra]
    cmp al, 0x61
    jl .fin
    cmp al, 0x7A
    jg .fin
    sub al, 0x20
    mov byte [letra], al
.fin:
    ret

print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

derrota:
    mov ecx, msj_derrota
    mov edx, longitud_7
    call print
    jmp fin

victoria:
    mov ecx, tablero
    movzx edx, byte [longitud_palabra]
    call print
    
    mov ecx, salto
    mov edx, 1
    call print
    
    mov ecx, msj_victoria
    mov edx, longitud_6
    call print
    jmp fin