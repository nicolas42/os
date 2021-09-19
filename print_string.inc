;;;
;;; Prints character strings in BX register 
;;;
print_string:
    pusha                       ; store all register values onto the stack

print_char:
    mov al, [bx]                ; move character value at address in bx into al
    cmp al, 0
    je end_print                ; jump if equal (al = 0) to halt label
    int 0x10                    ; print character in al
    add bx, 1                   ; move 1 byte forward/ get next character
    jmp print_char              ; loop

end_print:
    popa                        ; restore registers from the stack 
    ret

