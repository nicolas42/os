;;;
;;; Simple Boot Sector that prints characters using BIOS interrupts
;;;
    org 0x7c00                  ; 'origin' of Boot code; helps make sure addresses don't change

    ;; Set video mode
    mov ah, 0x00                ; int 0x10/ ah 0x00 = set video mode
    mov al, 0x01                ; 40x25 text mode
    int 0x10

    ;; Change color/Palette
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01
    int 0x10

    ;; Tele-type output strings
    mov bx, testString          ; moving memory address at testString into BX register

    call print_string
    mov bx, string2
    call print_string

    mov dx, 0x12AB              ; sample hex number to print
    call print_hex

    ;; End pgm
    jmp $                       ; keep jumping to here; neverending loop

    ;; Included Files
    include 'print_string.asm'
    include 'print_hex.asm'

    ;; Variables
testString:     db 'Char test: Testing', 0xA, 0xD, 0   ; 0/null to null terminate
string2:        db 'Hex Test: ', 0

    ;; Boot Sector magic
    times 510-($-$$) db 0       ; pads out 0s until we reach 510th byte

    dw 0xaa55                   ; BIOS magic number; BOOT magic #
