;************************************** bios_print.asm **************************************      
      bios_print:       ; A subroutine to print a string on the screen using the bios int 0x10.
                        ; Expects si to have the address of the string to be printed.
                        ; Will loop on the string characters, printing one by one. 
                        ; Will Stop when encountering character 0.
           
                     pusha                 ; push all registers used for general purposes to the stack
                .print_loop:               ; local label used to loop for printing
                     xor ax,ax             ; set initial value of ax to zero
                     lodsb                 ; used to load a byte from the location of si to al and increment si
                     or al, al             ; set the zero flag if al contains the value zero
                     jz .done              ; jump to label "done" if the flag is set to zero
                     mov ah, 0x0E          ; set mode to print character function
                     int 0x10              ; print character function to print character loaded in al
                     jmp .print_loop       ; repeat steps by continue looping to get next character
                
                .done:                     ; when reached indicates that loop ended and exits
                     popa                ; pop all general purpose registers back from the stack and restore them
                     ret                   ; Set PC register to return address after poping it from the stack
