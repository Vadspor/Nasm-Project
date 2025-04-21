global start
    extern CreateFileA
    extern WriteFile
    extern CloseHandle
    extern ExitProcess
    extern GetLastError

section .data
    a: DQ 12, 17, 19
    c1: DQ 15
    c2: DQ 26
    biff DQ 0
    filename DB 'output.txt', 0
    minus DB '-', 0 
    buffer TIMES 16 DB 0                         
    bytes_written DQ 0
    error_code DQ 0

section .text
    start:
    MOV RAX, [a+8]
    SUB RAX, [a]
    IMUL RAX, [a+16]

    MOV RBX, [a]
    ADD RBX, [a+8]

    MOV RCX, [c1]
    ADD RCX, [c2]

    MOV RDX, [a+8]
    SAL RDX, 4

loop1:
    CMP RCX, -5
    JL end
    
    SUB RCX, 3

    TEST RCX, 1
    JZ loop1
    JMP ifnoeven

ifnoeven:
    ADD RBX, RAX
    JMP loop1

end:
    neg rcx
    mov [buffer], rcx

itoa:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    mov rax, rcx
    lea rdi, [buffer+10]
    mov rcx, 10
    mov qword [rbp-8], 0

divloop:
    xor rdx, rdx
    idiv rcx
    add rdx, 0x30
    dec rdi
    mov byte [rdi], dl
    inc qword [rbp-8]
    cmp rax, 0
    jnz divloop
    mov rax, rdi
    mov [buffer], rdi
    mov rax, [buffer]
    leave
   
    sub rsp, 56
    mov rcx, filename
    mov rdx, 0C0000000h
    mov r8, 0
    mov r9, 0
    mov r10, 2
    mov [rsp + 32], r10
    mov r10, 128  
    mov [rsp + 40], r10 
    mov [rsp + 48], r9
                      
    call CreateFileA
    add rsp, 56                         

    cmp rax, -1                       
    je get_error                 
    
    mov r8, 0
    mov r9, 0
    mov rcx, rax
    mov [biff], rax
    lea rdx, [minus]                   
    mov r8, 1           
    call WriteFile   

    cmp rax, -1                          
    je get_error 


    mov r8, 0
    mov r9, 0
    mov rcx, [biff]                                              
    lea rdx, [buffer+9]                 
    mov r8, 1                                
    call WriteFile                          

    cmp rax, -1                         
    je get_error

    mov rdi, rax                       
    call CloseHandle                

exit_program:
    xor rcx, rcx                         
    call ExitProcess                 

get_error:
    call GetLastError                   
    mov [error_code], rax               
    jmp exit_program    