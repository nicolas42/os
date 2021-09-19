
org 0x7c00                  ; origin of boot code, helps make addresses not change 

mov ah, 0x0e                ; int 10 / ah 0x0e for BIO teletype output 
mov bx, test_string         ; move the test_string address into b 
jmp print_string


print_string:

    mov al, [bx]                ; get character at bx
    cmp al, 0                   ; sets zero flag
    je here                     ; jump if equal. (al == 0)
    int 0x10                    ; print character
    add bx,1                    ; move forward 
    jmp print_string 


test_string: db 'hello',0       ; 0/null to null terminate 


here:
    jmp here                ; jump repeatedly to label 'loop'; neverending

    times 510-($-$$) db 0   ; pads out 0s until we reach 510th byte

    dw 0xaa55               ; BIOS magic number; BOOT magic #





; $ = value of current offset
; $$ = base address of current addressing space


; labels are just memory addresses that you can refer to later 
; to make things easier for yourself 

; org tells you where the bios code starts
; It helps makes sure that addresses don't change
; why does this happen otherwise?

; Conditional Jumps
; ------------------
; jump here if al and 0 are equal 
;
;    cmp al, 0                   ; sets zero flag
;    je here                     ; jump if equal. (al == 0)
;
; In more detail the compare instruction sets the zero flag if al and 0 are equal
; then je does the jump if the zero flag is set.




