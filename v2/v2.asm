global _start

    extern CreateFileA
    extern WriteFile
    extern CloseHandle
    extern ExitProcess
    extern GetLastError

section .data
    filename db 'output.txt', 0         ; Імя файлу
    buffer times 16 db 0                         ; Буфер для зберігання значення RCX
    ; biff dq 100
    bytes_written dq 0                  ; Лічильник записаних байтів
    error_code dq 0                     ; Змінна для зберігання коду помилки

    
section .text
    start:
    mov rcx, 42                         ; Наприклад, число 42
    mov [buffer], rcx                    ; Копіюємо значення RCX у буфер

itoa:
    push rbp
    mov rbp,rsp
    sub rsp,8
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
    ; ret
   
    sub rsp, 56
    mov rcx, filename
    mov rdx, 0C0000000h
    mov r8, 0
    mov r9, 0 
    mov r10, 2 ; Всегда создавать новый файл
    mov [rsp + 32], r10
    mov r10, 128  ; обычный файл без атрибутов
    mov [rsp + 40], r10 
    mov [rsp + 48], r9
                      
    call CreateFileA
    add rsp, 56                         ; Виклик функції CreateFileA

    ; 3. Перевірка результату CreateFileA
    cmp rax, -1                          ; Порівнюємо з INVALID_HANDLE_VALUE
    je get_error                         ; Якщо помилка, йдемо на get_error

    ; 4. Записати дані у файл
    mov r8, 0
    mov r9, 0
    mov rcx, rax                            ; Дескриптор файлу (перший параметр)
    ; mov rdx, buffer                        
    lea rdx, [buffer+8]                    ; Буфер з даними для запису (другий параметр)
    mov r8, 64                         ; Кількість байтів для запису (третій параметр)
    ; lea r9, [bytes_written]              ; Куди записати кількість записаних байтів (четвертий параметр)
    call WriteFile   

    cmp rax, -1                          ; Порівнюємо з INVALID_HANDLE_VALUE
    je get_error                         ; Якщо помилка, йдемо на get_error

    ; 5. Закрити файл
    mov rdi, rax                        ; Дескриптор файлу
    call CloseHandle                     ; Виклик функції CloseHandle


exit_program:
    ; Завершення програми
    xor rcx, rcx                         ; Код виходу (0)
    call ExitProcess                     ; Виклик функції ExitProcess

get_error:
    ; Отримуємо код помилки через GetLastError
    call GetLastError                    ; Отримуємо код помилки
    mov [error_code], rax                ; Зберігаємо код помилки для відладки
    jmp exit_program                     ; Вихід з програми


