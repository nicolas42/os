;;;
;;; print_registers.asm: prints registers & mem addresses to screen
;;;
print_registers:
    pusha
    mov si, regString
    call print_string
    call print_hex          ; print dx

    mov byte [regString+2], 'a'
    call print_string
    mov dx, ax
    call print_hex          ; print ax

    mov byte [regString+2], 'b'
    call print_string
    mov dx, bx
    call print_hex          ; print bx

    mov byte [regString+2], 'c'
    call print_string
    mov dx, cx
    call print_hex          ; print cx

    mov word [regString+2], 'si'
    call print_string
    mov dx, si
    call print_hex          ; print si

    mov byte [regString+2], 'd'
    call print_string
    mov dx, di
    call print_hex          ; print di

    mov word [regString+2], 'cs'
    call print_string
    mov dx, cs
    call print_hex          ; print cs

    mov byte [regString+2], 'd'
    call print_string
    mov dx, ds
    call print_hex          ; print ds

    mov byte [regString+2], 'e'
    call print_string
    mov dx, es
    call print_hex          ; print es

    mov ah, 0Eh             ; print newline
    mov al, 0Ah
    int 10h
    mov al, 0Dh
    int 10h

    popa
    ret

    ;; Variables
regString: db 0Ah,0Dh,'dx         ',0 ; hold string of current register
