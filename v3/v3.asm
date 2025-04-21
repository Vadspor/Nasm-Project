global start
section .data
    msg:	db "Hello world", 0 ; Zero is Null terminator 
    fmt:    db "%s", 10, 0 ; printf format string follow by a newline(10) and a null terminator(0), "\n",'0'
    error_code dq 0  
    
section .text
    start:
    
    call GetLastError          
    mov [error_code], rax  
    
    extern add
    extern printf                ; оголошення зовнішньої функції
    extern CreateFileA
    extern WriteFile
    extern CloseHandle
    extern ExitProcess
    extern GetLastError

    ; Передаємо аргументи на стек в зворотному порядку
    ; sub rsp, 40   
    push rbp                 

    ; push 6
    ; push 2
    ; call add     ; add(2, 6)

    mov	rdi, fmt
    mov	rsi, msg
    mov rax, 0
    call printf  ; printf(format, eax)

    ; Після виклику printf, стек потрібно очистити від аргументів
    ; add rsp, 40
    pop rbp

    get_error:
    call GetLastError          
    mov [error_code], rax      

    ; Завершення програми
    mov rcx, 0                        ; код виходу
    call ExitProcess
