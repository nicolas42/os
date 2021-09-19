;;; =======================================================================
;;; Kernel.asm: basic 'kernel' loaded from our bootsector
;;; =======================================================================

    ;; --------------------------------------------------------------------
    ;; Screen & Menu Set up
    ;; --------------------------------------------------------------------
main_menu:
    ;; Reset screen state
    call resetTextScreen

    ;; print menu header & options
    mov si, menuString          
    call print_string

    ;; --------------------------------------------------------------------
    ;; Get user input, print to screen & choose menu option or run command
    ;; --------------------------------------------------------------------
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
    je filebrowser
    cmp al, 'R'                 ; 'warm' reboot option
    je reboot
    cmp al, 'P'                 ; print register values
    je registers_print
    cmp al, 'G'                 ; graphics mode test
    je graphics_test
    cmp al, 'N'                 ; e(n)d our current program
    je end_program
    mov si, failure             ; command not found, boo! D:
    call print_string
    jmp get_input

    ;; -----------------------------------------------------------
    ;; Menu F) - File/Program browser & loader
    ;; -----------------------------------------------------------
filebrowser:
    ;; Reset screen state
    call resetTextScreen

    mov si, fileTableHeading
    call print_string

    ;; Load File Table string from its memory location (0x1000:0000), print file
    ;;  and program names & sector numbers to screen, for user to choose
    ;; -------------------------------------------------------------------
    xor cx, cx              ; reset counter for # chars in file/pgm name
    mov ax, 0x1000          ; file table location
    mov es, ax              ; ES = 0x1000
    xor bx, bx              ; ES:BX = 0x1000:0
    mov ah, 0x0e            ; get ready to print to screen

fileTable_Loop:
    inc bx
    mov al, [ES:BX]
    cmp al, '}'             ; at end of filetable?
    je stop
    cmp al, '-'             ; at sector number of element?
    je sectorNumber_Loop
    cmp al, ','             ; between table elements?
    je next_element
    inc cx                  ; increment counter
    int 0x10
    jmp fileTable_Loop

sectorNumber_Loop:
    cmp cx, 21
    je fileTable_Loop
    mov al, ' '
    int 0x10
    inc cx
    jmp sectorNumber_Loop

next_element:
    xor cx, cx              ; reset counter
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10
    mov al, 0xA
    int 0x10
    mov al, 0xD
    int 0x10
    jmp fileTable_Loop
stop:
    mov si, goBackMsg       ; show go back message
    call print_string

    mov ah, 0x00            ; get keystroke
    int 0x16
    jmp main_menu           ; go back to main menu

    ;; -----------------------------------------------------------
    ;; Menu R) - Reboot: far jump to reset vector
    ;; -----------------------------------------------------------
reboot:
    jmp 0xFFFF:0x0000

    ;; -----------------------------------------------------------
    ;; Menu P) - Print Register Values
    ;; -----------------------------------------------------------
registers_print:
    ;; Reset screen state
    call resetTextScreen

    ;; print register values to screen
    mov si, printRegHeading
    call print_string

    call print_registers

    ;; Go back to main menu
    mov si, goBackMsg
    call print_string
    mov ah, 0x00
    int 0x16                ; get keystroke
    jmp main_menu           ; go back to main menu

    ;; -----------------------------------------------------------
    ;; Menu G) - Graphics Mode Test(s)
    ;; -----------------------------------------------------------
graphics_test:
    ;; Reset screen state (gfx)
    call resetGraphicsScreen

    ;; Test Square
    mov ah, 0x0C            ; int 0x10 ah 0x0C - write gfx pixel
    mov al, 0x02            ; green
    mov bh, 0x00            ; page #

    ;; Starting pixel of square
    mov cx, 100             ; column #
    mov dx, 100             ; row #
    int 0x10

    ;; Pixels for columns
squareColLoop:
    inc cx
    int 0x10
    cmp cx, 150
    jne squareColLoop

    ;; Go down one row
    inc dx
    int 0x10
    mov cx, 99
    cmp dx, 150
    jne squareColLoop       ; pixels for next row

    mov ah, 0x00
    int 0x16                ; get keystroke
    jmp main_menu

    ;; -----------------------------------------------------------
    ;; Menu N) - End Pgm
    ;; -----------------------------------------------------------
end_program:
    cli                         ; clear interrupts
    hlt                         ; halt the cpu

    ;; ===========================================================
    ;; End Main Logic
    ;; ===========================================================

    ;; -----------------------------------------------------------
    ;; Include Files
    ;; -----------------------------------------------------------
    include "../print/print_string.asm"
    include "../print/print_hex.asm"
    include "../print/print_registers.asm"
    include "../screen/resetTextScreen.asm"
    include "../screen/resetGraphicsScreen.asm"

    ;; -----------------------------------------------------------
    ;; Variables
    ;; -----------------------------------------------------------
menuString:     db '---------------------------------',0xA,0xD,\
        'Kernel Booted, Welcome to QuesOS!', 0xA, 0xD,\
        '---------------------------------', 0xA, 0xD, 0xA, 0xD,\
        'F) File & Program Browser/Loader', 0xA, 0xD,\
        'R) Reboot', 0xA, 0xD, \
        'P) Print Register Values', 0xA, 0xD,\ 
        'G) Graphics Mode Test', 0xA, 0xD, 0

success:        db 0xA, 0xD, 'Command ran successfully!', 0xA, 0xD, 0
failure:        db 0xA, 0xD, 'Oops! Something went wrong :(', 0xA, 0xD, 0

fileTableHeading:       db '------------         ------',0xA,0xD,\
        'File/Program         Sector', 0xA, 0xD,\
        '------------         ------',0xA, 0xD, 0

printRegHeading:        db '--------   ------------',0xA,0xD,\
        'Register   Mem Location', 0xA,0xD,\
        '--------   ------------',0xA,0xD,0

goBackMsg:      db 0xA, 0xD, 0xA, 0xD, 'Press any key to go back...', 0
cmdString:      db '', 0

    ;; -----------------------------------------------------------
    ;; Sector Padding magic
    ;; -----------------------------------------------------------
    times 1024-($-$$) db 0       ; pads out 0s until we reach 512th byte
