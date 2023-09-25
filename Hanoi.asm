; Agradecimentos: https://mentebinaria.gitbook.io/assembly/a-base/registradores-de-proposito-geral

section .text                         ; Usada para armazenar o código executável do nosso programa

    global _start                     ; Inicio do código


    _start:                           ; iniciando

        push ebp                      ; empurra o registrador ebp na pilha (para ser a base)
        mov ebp, esp                  ; aponta o ponteiro do topo da pilha (esp) para a base

        mov eax, 7                    ; Definindo o número de discos que terá na torre A
        
        ; para ficar "brincando" de auxiliar ganhar o valor de destino e destino ganhar valor de auxiliar, é necessario colocar os valores na pilha

        ; Empurrando as torres e a quantidade de discos na pilha de referencia para que fiquem em ordem
        push dword 2                  ; Torre Auxiliar
        push dword 3                  ; Torre Destino
        push dword 1                  ; Torre Origem
        
        push eax                      ; 7 -> numero inicial de discos

        call hanoi                    ; Chamando a label Hanoi

        ; Gerando uma interrupçao para a finalizaçao do programa
        mov eax, 1                    ; Parametro de saida do sistema
        mov ebx, 0                    ; Parametro para utilizar a saida padrão  
        int 128                       ; Interrupção Kernel 



; Labels que serão usados durante o funcionamento do codigo
    hanoi: 

        ;[ebp+8] número de discos restantes na Torre de origem
        ;[ebp+12] = Torre de origem
        ;[ebp+16] = Torre de trabalho
        ;[ebp+20] = Torre de destino

        push ebp                      ; empurra o registrador ebp na pilha (para ser a base)
        mov ebp,esp                   ; aponta o ponteiro do topo da pilha (esp) para a base

        mov eax, [ebp+8]              ; move para o registrador ax o numero de discos na Torre de origem
        
        cmp eax, 0                    ; verifica se Ainda há disco a ser movido na torre de origem
        je desempilhar                ; caso nao tenha nunhum disco, pula para desempilhar
        
        ; Primeira recursividade    
        push dword [ebp+16]           ; Empurra a torre Auxiliar
        push dword [ebp+20]           ; Empurra a torre Destino
        push dword [ebp+12]           ; Empurra a torre Origem
        
        dec eax                       ; tira o disco do topo da torre de origem para ser colocado outra torre
        push dword eax                ; empurra o numero de discos restantes a serem movidos na Torre de origem
        
        call hanoi                    ; chama a label hanoi para guardar a linha de retorno (recursao)
        
        add esp,16                    ; após retornar da chamada da label hanoi, remove o "lixo" da pilha que está ocupando espaço na memoria


        ; Printando os movimentos
        push dword [ebp+16]           ; empilha o torre de Saida
        push dword [ebp+12]           ; empilha o torre de Ida
        push dword [ebp+8]            ; empilha o disco
        
        call imprime                  ; chama a label para imprimir os movimentos
        
        add esp, 12                   ; após retornar da chamada da label hanoi, remove o "lixo" da pilha que está ocupando espaço na memoria
        
        
        ; Segunda recursividade
        push dword [ebp+12]           ; Empurra a torre Origem
        push dword [ebp+16]           ; Empurra a torre Trabalho
        push dword [ebp+20]           ; Empurra a torre Destino
        
        mov eax, [ebp+8]              ; move para o registrador eax o número de discos restantes
        
        dec eax                       ; tira o disco do topo da torre de origem para ser colocado outra torre
        push dword eax                ; empurra o numero de discos restantes a serem movidos na Torre de origem
    
        call hanoi                    ; chama a label hanoi para guardar a linha de retorno (recursao)

    desempilhar: 

        mov esp, ebp                  ; aponta o ponteiro da base da pilha (ebp) para o topo
        pop ebp                       ; tira o elemento do topo da pilha e guarda o valor em ebp
        ret                           ; retira o ultimo valor do topo da pilha e da um jump para ele (a linha de retorno nesse caso)

    imprime:

        push ebp                      ; empurra o registrador ebp na pilha (para ser a base)
        mov ebp, esp                  ; aponta o ponteiro do topo da pilha (esp) para a base
        
        mov eax, [ebp + 8]            ; coloca no registrador ax o disco a ser movido
        add al, 48                    ; conversao na tabela ASCII
        mov [disco], al               ; coloca o valor no [disco] para o print

        mov eax, [ebp + 12]           ; coloca no registrador ax a torre de onde o disco saiu
        add al, 64                    ; conversao na tabela ASCII
        mov [torre_saida], al         ; coloca o valor no [torre_saida] para o print

        mov eax, [ebp + 16]           ; coloca no registrador ax a torre de onde o disco foi
        add al, 64                    ; conversao na tabela ASCII
        mov [torre_ida], al           ; coloca o valor no [torre_ida] para o print

        mov edx, lenght               ; tamanho da mensagem
        mov ecx, msg                  ; mensagem em si
        mov ebx, 1                    ; dá permissão para a saida
        mov eax, 4                    ; informa que será uma escrita
        int 128                       ; Interrupção para kernel

        mov     esp, ebp              ; aponta o ponteiro da base da pilha (ebp) para o topo
        pop     ebp                   ; tira o elemento do topo da pilha e guarda o valor em ebp
        ret                           ; retira o ultimo valor do topo da pilha e da um jump para ele (a linha de retorno nesse caso)

; Declaração de dados: 
section .data                         ; Usada para armazenar dados inicializados do programa, por exemplo uma variável global.

    ; Definindo a mensagem
    msg:
                          db        "disc: "   
        disco:            db        " "
                          db        "   "                      
        torre_saida:      db        " "  
                          db        " -> "     
        torre_ida:     db        " ", 0xa  ; para quebrar linha
        
        lenght            equ       $-msg
