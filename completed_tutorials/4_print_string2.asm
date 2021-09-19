
org 0x7c00                  ; origin of boot code, helps make addresses not change 

jmp print_test_string

print_test_string:
    mov ah, 0x0e                ; int 10 / ah 0x0e for BIO teletype output 
    mov bx, test_string         ; move the test_string address into b 
    jmp print_string

print_string:
    mov al, [bx]                
    cmp al, 0                   
    je infinite_loop                     
    int 0x10                    
    add bx,1                    
    jmp print_string 


infinite_loop:
    jmp infinite_loop                




test_string: db 'oh dear lord how the money flowed in',0       ; 0/null to null terminate 

times 510-($-$$) db 0   ; pad out 0s until we reach 510th byte

dw 0xaa55               ; BIOS magic number; BOOT magic #




; $ = value of current offset
; $$ = base address of current addressing space

