 ;************************************** read_disk_sectors.asm **************************************
      read_disk_sectors: ; This function will read a number of 512-sectors stored in DI 
                         ; The sectors should be loaded at the address starting at [disk_read_segment:disk_read_offset]


        pusha                           ; push all registers used for general purposes to the stack
        add di,[lba_sector]             ; add lba_sector to di (last sector to read)
        mov ax,[disk_read_segment]      ; load address where read sector(s) will be loaded to es through ax
        mov es,ax                       
        add bx,[disk_read_offset]       ; store the offset to bx
        mov dl,[boot_drive]             ; Read from boot drive to dl
    .read_sector_loop:
        call lba_2_chs                  ; convert the lbs value stored in [lba_sector] to CHS.
        mov ah,0x2                      ; read sectors through setting the interrupt function 0x2 
        mov al,0x1                      ; read one sector
        mov cx,[Cylinder]               ; Store Cylinder into CX
        shl cx,0x8                      ; Shift 8 bits left 
        or cx,[Sector]                  ; Store first 6 bits in [Sector] to CX 
        mov dh,[Head]                   ; set dh to [head]
        int 0x13                        ; intiate 0x13 interrupt Read 
        jc .read_disk_error             ; jump to .read_disk_error if carry flag is set 
        mov si,dot                      ; print a '.' for successful sector read
        call bios_print
        inc word [lba_sector]           ; increment pointer to the next sector
        add bx,0x200                    ; Advance to the next memory location
        cmp word[lba_sector],di         ; Check if di equals current sector
        jl .read_sector_loop            ; If not done continue looping
        jmp .finish                     ; If done skip following code and finish
    .read_disk_error:
        mov si,disk_error_msg           ; print an error message
        call bios_print 
        jmp hang
     .finish:
        popa                            ; pop all general purpose registers back from the stack and restore them
        ret                             ; Set PC register to return address after poping it from the stack
