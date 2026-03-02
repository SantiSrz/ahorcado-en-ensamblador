section .data
    mensaje db 'Introduce una lñetra', 0xA
     longitud equ $ - mensaje

section .bss
    caracter resb 1

section .text
    global _start

_start:
    ; Imprimir mensaje
    mov eax, 4          
    mov ebx, 1          
    mov ecx, mensaje    
    mov edx, longitud   
    int 0x80

     ; Leer un caracter
    mov eax, 3         
    mov ebx, 0          
    mov ecx, caracter  
    mov edx, 1          
    int 0x80

    ; Salir
    mov eax, 1          
    mov ebx, 0         
    int 0x80