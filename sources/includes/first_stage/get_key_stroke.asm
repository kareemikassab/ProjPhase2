;************************************** get_key_stroke.asm **************************************      
        get_key_stroke: ; A routine to print a confirmation message and wait for key press to jump to second boot stage
            
            pusha           ; push all registers used for general purposes to the stack
            mov ah,0x0      ; Set ah to zero to wait for a keyboard input
            int 0x16        ; intiate BIOS interrupt 0x16
            popa            ; pop all general purpose registers back from the stack and restore them
            ret             ; Set PC register to return address after poping it from the stack
