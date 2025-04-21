global start
NULL equ 0
MB_OK equ 0
    extern MessageBoxA
    extern ExitProcess
section .data
    hello: db 'Hello, World', 0
    title: db 'Title', 0
section .text
    start:
    sub rsp, 40
    mov r9, MB_OK
    mov r8, title
    mov rdx, hello
    mov rcx, NULL
    call MessageBoxA
    xor ecx, ecx
    call ExitProcess