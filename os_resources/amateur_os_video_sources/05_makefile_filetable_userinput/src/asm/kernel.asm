;;;
;;; Kernel.asm: basic 'kernel' loaded from our bootsector
;;;
    ;; Set video mode
    mov ah, 0x00                ; int 0x10/ ah 0x00 = set video mode
    mov al, 0x01                ; 40x25 text mode
    int 0x10

    ;; Change color/Palette
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01
    int 0x10

    ;; Print Screen Heading and Menu options
    mov si, menuString
    call print_string

    ;; Get user input, print to screen & choose menu option or run command
get_input:
    mov di, cmdString           ; di now pointing to cmdString
keyloop:
    mov ax, 0x00                ; ah = 0x00, al = 0x00
    int 0x16                    ; BIOS int get keystroke ah=00, character goes into al

    mov ah, 0x0e
    cmp al, 0xD                 ; did user press 'enter' key?
    je run_command
    int 0x10                    ; if not, print input character to screen
    mov [di], al                ; store input character to string
    inc di                      ; go to next byte at di/cmdString
    jmp keyloop                 ; loop for next character from user

run_command:
    mov byte [di], 0            ; null terminate cmdString from di
    mov al, [cmdString]
    cmp al, 'F'                 ; file table command/menu option
    jne not_found
    cmp al, 'N'                 ; e(n)d our current program
    je end_program
    mov si, success             ; command found! hooray
    call print_string
    jmp get_input

not_found:
    mov si, failure             ; command not found, frowny face
    call print_string
    jmp get_input

print_string:
    mov ah, 0x0e                ; int 10h/ ah 0x0e BIOS teletype output
    mov bh, 0x0                 ; page number
    mov bl, 0x07                ; color

print_char:
    mov al, [si]                ; move character value at address in bx into al
    cmp al, 0
    je end_print                ; jump if equal (al = 0) to halt label
    int 0x10                    ; print character in al
    add si, 1                   ; move 1 byte forward/ get next character
    jmp print_char              ; loop

end_print:
    ret

end_program:
    cli                         ; clear interrupts
    hlt                         ; halt the cpu

    ;; Variables
menuString:     db '---------------------------------',0xA,0xD,\
        'Kernel Booted, Welcome to QuesOS!', 0xA, 0xD,\
        '---------------------------------', 0xA, 0xD, 0xA, 0xD,\
        'F) File & Program Browser/Loader', 0xA, 0xD, 0
success:        db 0xA, 0xD, 'Command ran successfully!', 0xA, 0xD, 0
failure:        db 0xA, 0xD, 'Oops! Something went wrong :(', 0xA, 0xD, 0
cmdString:      db ''

    ;; Sector Padding magic
    times 512-($-$$) db 0       ; pads out 0s until we reach 512th byte
