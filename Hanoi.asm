section    .text
    global _start       
_start:                
    push ebp            ; empilha o registrador ebp na pilha
    mov esp, ebp        ; ebp recebe o ponteiro para o topo da pilha
    
                        ; empilhar os pinos 'A' 'B' 'C'
                        ; empilhar numero de discos 'n'
    call hanoi                    
    
hanoi:
    cmp byte[ebp+8] , 1 ; if discos == 1
    je caso_base        ; condicional do caso base
    
caso_base:
                        ; printar de A para C
    ret
    
print:
    mov    edx, len    ;message length
    mov    ecx, msg    ;message to write
    mov    ebx, 1      ;file descriptor (stdout)
    mov    eax, 4      ;system call number (sys_write)
    int    0x80        ;call kernel
    ret

section    .data
