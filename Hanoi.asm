
.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    disc dd 3                 ; Número de discos
    origem db "A", 0          ; Pino de origem
    auxiliar db "B", 0        ; Pino auxiliar
    destino db "C", 0         ; Pino de destino

.code
main:
    ; Chame a função recursiva da Torre de Hanói aqui
    invoke hanoi, disc, addr origem, addr auxiliar, addr destino

    ; Termina o programa
    invoke ExitProcess, 0

hanoi PROC
    ; Receba os parâmetros: disc, origem, auxiliar, destino
    push ebp        ; salva o registrador ebp na pilha
    mov ebp, esp    ; ebp recebe o endereço do topo da pilha

    ; Parâmetros:
    ; [ebp+8] = disc (número de discos)
    ; [ebp+12] = origem (pino de origem)
    ; [ebp+16] = auxiliar (pino auxiliar)
    ; [ebp+20] = destino (pino de destino)

    ; Verifique o caso base: se disc for igual a 1, mova o disco da origem para o destino
    cmp dword ptr [ebp+8], 1
    je caso_base

    ; Caso contrário, siga os passos da recursão

    ; PASSO 1: Mova n - 1 discos do pino de origem para o pino auxiliar, usando o pino de destino como pino auxiliar
    ; Chame recursivamente a função hanoi
    ; Você precisará trocar origem e auxiliar como parte do processo
    push dword ptr [ebp+16]     ; Pino auxiliar
    push dword ptr [ebp+20]     ; Pino destino
    push dword ptr [ebp+12]     ; Pino origem
    push dword ptr [ebp+8] - 1 ; n - 1 (um disco a menos)
    call hanoi

    ; PASSO 2: Mova o disco restante (o maior) do pino de origem para o pino de destino
    ; Use instruções como mov ou outras para realizar essa operação
    ; Imprima os movimentos dos discos, se desejar

    ; PASSO 3: Mova os n - 1 discos do pino auxiliar para o pino de destino, usando o pino de origem como pino auxiliar
    ; Chame recursivamente a função hanoi novamente
    ; Novamente, você precisará trocar origem e auxiliar como parte do processo
    push dword ptr [ebp+12]     ; Pino origem
    push dword ptr [ebp+16]     ; Pino auxiliar
    push dword ptr [ebp+20]     ; Pino destino
    push dword ptr [ebp+8] - 1 ; n - 1 (um disco a menos)
    call hanoi

caso_base:
    ; Implemente o código para mover um disco da origem para o destino
    ; Você pode imprimir os movimentos dos discos, se desejar

    ; Termina a função
    pop ebp
    ret
hanoi ENDP


end main
