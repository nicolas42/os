;
; Simple boot sector that prints characters using BIOS interrupts
;

; print a character 
;mov ah, 0x0e                ; int 10 / ah 0x0e BIO teletype output 
;mov al, "T"                 ; character we want to print 
;int 0x10    

    org 0x7c00                  ; origin of boot code, helps make addresses not change 

    ;; set video mode / resolution 
    mov ah, 0x00                ; int 0x10/ ah 0x00 = set video mode 
    mov al, 0x03                ; 80x25 text mode 
    int 0x10                    

    ;; change color/palette 
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0x01
    int 0x10

    ;; tele-type output 
    mov ah, 0x0e                ; int 10 / ah 0x0e for BIOS teletype output 
    mov bx, str1                ; move the test_string address into b 
    call print_string 
    mov bx, str2                ; move the test_string address into b 
    call print_string 

    jmp end_program


print_string:
    mov al, [bx]                
    cmp al, 0                   
    je end_print_string                     
    int 0x10                    
    add bx,1                    
    jmp print_string 
end_print_string:
    ret


str1: db 'test',0xA, 0xD, 0
str2: db 'also a test', 0

end_program:
    jmp $                

    times 510-($-$$) db 0   ; pad out 0s until we reach 510th byte

    dw 0xaa55               ; BIOS magic number; BOOT magic #





; Returning
; ----------
; If you call an address rather than just jumping to it the system will 
; save the previous address that you were at prior to making the call.
; You can then go back to that address with the return (ret) instruction
; This is convenient :)
;
; back to the shadow flame of udun


; $ = value of current offset
; $$ = base address of current addressing space

; 0x10 if for video stuff in general 

; Setting the video mode usually clears it