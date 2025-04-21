global _start

    extern CreateFileA
    extern WriteFile
    extern CloseHandle
    extern ExitProcess
    extern GetLastError

section .data
    filename db 'output.txt', 0         ; Імя файлу
    buffer dq 0                         ; Буфер для зберігання значення RCX
    bytes_written dq 0                  ; Лічильник записаних байтів
    error_code dq 0                     ; Змінна для зберігання коду помилки

section .text
    start:
    mov rcx, 42                         ; Наприклад, число 42
    mov [buffer], rcx                   ; Копіюємо значення RCX у буфер

; itoa:
;     push rbp
;     mov rbp,rsp
;     sub rsp,8
;     mov rax,rcx
;     lea rdi,[buffer+10]
;     mov rcx,10
;     mov qword [rbp-8],0

; divloop:
;     xor rdx,rdx
;     idiv rcx
;     add rdx,0x30
;     dec rdi
;     mov byte [rdi],dl
;     inc qword [rbp-8]
;     cmp rax,0
;     jnz divloop
;     mov rax,rdi
;     ; leave
;     ; ret

    sub rsp, 40
    mov rcx, filename
    mov rdx, 0C0000000h
    mov r8, 0
    mov r9, 0 

    ; mov r10, filename 
    ; mov [rsp], r10
    ; mov r10, 0C0000000h
    ; mov [rsp + 8], r10
    ; mov r10, 0 
    ; mov [rsp + 16], r10
    ; mov r10, 0
    ; mov [rsp + 24], r10
    mov r10, 2 
    mov [rsp + 32], r10
    mov r10, 128 
    mov [rsp + 40], r10
    mov r10, 0
    mov [rsp + 48], r10
  
    ; push r9
    ; mov r10, 128
    ; push r10
    ; mov r10, 2 
    ; push r10
    
    ; push 0
    ; push 128
    ; push 2
    call CreateFileA
    add rsp, 40
    
get_error:
    ; Отримуємо код помилки через GetLastError
    call GetLastError                    ; Отримуємо код помилки
    mov [error_code], rax                ; Зберігаємо код помилки для відладки
    jmp exit_program                     ; Вихід з програми

exit_program:
    ; Завершення програми
    xor rcx, rcx                         ; Код виходу (0)
    call ExitProcess                     ; Виклик функції ExitProcess

