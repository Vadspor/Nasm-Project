global start
    extern ExitProcess
    extern CreateFileA
    extern WriteFile
    extern CloseHandle

section .data
    a: dq 12, 17, 19
    c1 dq 15
    c2 dq 26
    filename db 'out.txt', 0
    min dq '-', 0
section .text
    start:
    mov rax, [a+8]
    sub rax, [a]
    imul rax, [a+16]

    mov rbx, [a]
    add rbx, [a+8]

    mov rcx, [c1]
    add rcx, [c2]

    mov rdx, [a+8]
    sal rdx, 4

l4:
    cmp rcx, -5
    jl next
    sub rcx, 3
    test rcx, 1
    jz l4
    add rbx, rax
    jmp l4
next:
    neg  rcx 
    add rcx, '0'
    mov [min+1], rcx
    sub rsp, 56
    mov rcx,  filename
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
    mov r13, rax

    mov rcx, rax
    mov rdx, min
    mov r8, 2
    mov r9, 0           
    call WriteFile   

    mov rcx, r13                       
    call CloseHandle                
                        
    xor rcx, rcx
    call ExitProcess