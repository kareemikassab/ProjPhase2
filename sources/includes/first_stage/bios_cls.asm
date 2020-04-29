;************************************** bios_cls.asm **************************************      
      bios_cls:   ; A routine to initialize video mode 80x25 which also clears the screen
        
        pusha           ; push all registers used for general purposes to the stack
        mov ah,0x0      ; Set ah to zero indicating the function for video mode
        mov al,0x3      ; set al to 3 refering to the 80x25 16 color text mode 
        int 0x10        ; perform system call to intialize video mode 80x25
        popa            ; pop all general purpose registers back from the stack and restore them
        ret             ; Set PC register to return address after poping it from the stack
