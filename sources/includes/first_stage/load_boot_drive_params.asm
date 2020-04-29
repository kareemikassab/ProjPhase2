;************************************** load_boot_drive_params.asm **************************************
      load_boot_drive_params: ; A subroutine to read the [boot_drive] parameters and update [hpc] and [spt]
            

        pusha               ; push all registers used for general purposes to the stack
        xor di,di           ; set di to zero as function 0x8 mandates that                         
        mov es,di
        mov ah,0x8          ; move function 0x8 to ah. this function fetches disk parameters
        mov dl,[boot_drive] ; move the disk number to dl
        int 0x13            ; intiate BIOS interrupt 0x13 
        inc dh              ; increment dh by 1 to get the number of head/cylinder
        mov word [hpc],0x0  ; Clear memory [hpc] by setting it to zero
        mov[hpc+1],dh       ; move dh into the lower byte of [hpc].
        and cx,0000000000111111b
                            ; Extract the sectors/track through getting the 6 right most bits of cx using and 
        mov word [spt],cx   ; Store value od cx (Sector value) into [spt]
        popa                ; pop all general purpose registers back from the stack and restore them
        ret                 ; Set PC register to return address after poping it from the stack
