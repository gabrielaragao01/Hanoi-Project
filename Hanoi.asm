
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
    push disc                   ; Empilha o número de discos
    push offset destino         ; Empilha o pino de destino
    push offset auxiliar        ; Empilha o pino auxiliar
    push offset origem          ; Empilha o pino de origem
    call hanoi                 ; Chama a função hanoi

    ; Limpe a pilha
    add esp, 16

    ; Termina o programa
    invoke ExitProcess, 0

hanoi PROC

        ;[ebp+8] = n (número de discos iniciais) 
        ;[ebp+12] = pino de origem
        ;[ebp+16] = pino de auxilio
        ;[ebp+20] = pino de destino

        push ebp                        ; salva o registrador ebp na pilha
        mov ebp,esp                     ; ebp recebe o endereço do topo da pilha

        mov eax,[ebp+8]                 ; pega o a posição do primeiro elemento da pilha e mov para eax
        cmp eax,0x0                     ; cmp faz o comparativo do valor que estar em eax com 0x0 = 0 em hexadecimal 
        jle fim                         ; se eax for menor ou igual a 0, vai para o fim, desempilhar
        
        ;PASSO1 - RECURSIVIDADE
        dec eax                         ; decrementa 1 de eax
        push dword [ebp+16]             ; coloca na pilha o pino de auxilio
        push dword [ebp+20]             ; coloca na pilha o pino de destino
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword eax                  ; poe eax na pilha como parâmetro n, já com -1 para a recursividade
        call funcaoHanoi                ; Chama a mesma função (recursividade)

        ;PASSO2 - MOVER PINO E IMPRIMIR
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+16]             ; pega o pino de origem referenciado pelo parâmetro ebp+16
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword [ebp+8]              ; coloca na pilha o pino de o numero de disco inicial
        call imprime                    ; Chama a função 'imprime'
        
        ;PASSO3 - RECURSIVIDADE
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword [ebp+16]             ; coloca na pilha o pino de auxilio
        push dword [ebp+20]             ; coloca na pilha o pino de destino
        mov eax,[ebp+8]                 ; move para o registrador eax o espaço reservado ao número de discos atuais
        dec eax                         ; decrementa 1 de eax

    push dword eax                      ; poe eax na pilha

        call hanoi
hanoi ENDP


end main
