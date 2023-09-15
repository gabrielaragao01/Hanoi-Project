.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    message db "Algoritmo da Torre de Hanoi com 3 discos", 0
    buffer db 11 dup(0)
    newline db 10, 0

.code
main PROC
    ; Exibe o título do algoritmo
    invoke StdOut, addr message

    ; Chama a função recursiva para resolver a Torre de Hanoi
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 3        ; Número de discos
    mov ebx, 1        ; Pino de origem (A)
    mov ecx, 2        ; Pino auxiliar (B)
    mov edx, 3        ; Pino de destino (C)
    call Hanoi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ; Termina o programa
    invoke ExitProcess, 0
main ENDP

Hanoi PROC
    ; Parâmetros:
    ;   EAX: Número de discos
    ;   EBX: Pino de origem
    ;   ECX: Pino auxiliar
    ;   EDX: Pino de destino
    ; Usos:
    ;   ESI, EDI

    cmp eax, 1            ; Caso base: um disco
    je  Done

    ; Move (N-1) discos do pino de origem para o pino auxiliar,
    ; usando o pino de destino como auxiliar
    push eax
    dec eax
    push edx
    push ecx
    push ebx
    call Hanoi

    ; Move o maior disco para o pino de destino
    pop ebx
    pop ecx
    pop edx
    push eax
    push ebx
    push edx
    call DisplayMove
    pop edx
    pop ebx
    pop eax

    ; Move (N-1) discos do pino auxiliar para o pino de destino,
    ; usando o pino de origem como auxiliar
    push ebx
    push ecx
    push edx
    push eax
    dec eax
    call Hanoi

Done:
    ret
Hanoi ENDP

DisplayMove PROC
    ; Parâmetros:
    ;   EAX: Número do disco (1, 2, 3, ...)
    ;   EBX: Pino de origem
    ;   EDX: Pino de destino

    pushad               ; Salva todos os registradores
    invoke StdOut, addr buffer
    invoke dwtoa, EAX, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr buffer
    invoke StdOut, addr buffer
    popad                ; Restaura todos os registradores
    ret
DisplayMove ENDP

end main
