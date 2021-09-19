;;; Basic Boot sector that will jump continuously
;;;

; fasm bootSect.asm
; qemu-system-i386 -drive format=raw,file=bootSect.bin,if=ide,index=0,media=disk


here:
    jmp here                ; jump repeatedly to label 'loop'; neverending

    times 510-($-$$) db 0   ; pads out 0s until we reach 510th byte

    dw 0xaa55               ; BIOS magic number; BOOT magic #


; $ = value of current offset
; $$ = base address of current addressing space


; Booting 
; -------------------

; To boot it seems you need to have 0x55AA at the end of the first
; 512 bytes of ... whatever is booting I suppose.  dunno
; This becomes 0xAA55 in x86 land because x86 is little endian.

; 
; look in first 512 bytes finds magic numbers at the end
; if it's there it tries to boot from the first 512 bytes
; 
; #bytes bs
; dd if=/dev/zero of=bootsect.bin bs=512 count=1
; 
; 
; xxd make hex dump or reverse
; 
; hexl-mode

; Endian-ness-ness 
; -------------------
; x86 is little endian.  regular numbers are big endian where the 
; most significant figure comes first
;
; Little endian is the opposite of how regular numbers work 
; in 123 the 1 stands for 100, the 2 for 20, and the 3 for just 3.
; So the first number (1) is the most significant you say.
; This regular way is called big endian.
;
; If you were to write that number in little endian format it would be 
; 321 - weird huh.  It's still the same number.  It's just written a different way 
; I don't know who decided to do things this way but they did so we just have 
; to deal with it.  
; To summarise - big endian is normal and little endian is the reverse of that 

