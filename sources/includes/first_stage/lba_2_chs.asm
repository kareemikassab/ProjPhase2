 ;************************************** lba_2_chs.asm **************************************
 lba_2_chs:  ; Convert the value store in [lba_sector] to its equivelant CHS values and store them in [Cylinder],[Head], and [Sector]
              

    pusha                           ; push all registers used for general purposes to the stack
    xor dx,dx                       ; set dx to zero
    mov ax, [lba_sector]            ; move [lba_sector] to ax
    div word [spt]                  ; divide ax by word[spt] and save remainder in dx, and quotient in ax
    inc dx                          ; increment the remainder by one to get the CHS sector
    mov [Sector],dx                 ; Store CHS sector in memory 
    xor dx,dx                       ; set dx to zero again
    div word [hpc]                  ; divide ax by word[hpc] and save remainder in dx, and quotient in ax
    mov [Cylinder],ax               ; move quotient value memory [Cylinder]
    mov [Head],dl                   ; move remainder value to memory [Head] 
    popa                            ; pop all general purpose registers back from the stack and restore them
    ret                             ; Set PC register to return address after poping it from the stack
