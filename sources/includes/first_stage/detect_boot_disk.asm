;************************************** detect_boot_disk.asm **************************************      
      detect_boot_disk: ; A subroutine to detect the the storage device number of the device we have booted from
                        ; After the execution the memory variable [boot_drive] should contain the device number
                        ; Upon booting the bios stores the boot device number into DL
          
            pusha                           ; push all registers used for general purposes to the stack
            mov si,fault_msg                ; move fault_msg to si
            xor ax,ax                       ; intialize ax to zero 
            int 13h                         ; intiate BIOS interrupt 0x13
            jc .exit_with_error             ; Jump to exit_with_error if carry flag is set (indicating that an error occured). 
            mov si,booted_from_msg          ; move booted_from_msg to si
            call bios_print                 ; call bios_print function
            mov [boot_drive],dl             ; move the boot drive number stored in dl register to place of boot_drive in memory
            cmp dl,0                        ; Check if dl indicates the floppy by comparing dl with zero
            je .floppy                      ; jump to .floppy if dl contains zero 
            call load_boot_drive_params     ; else call load_boot_drive_params 
            mov si,drive_boot_msg           ; move drive_boot_msg to si
            jmp .finish                     ; jump to finish and skip following code

    .floppy:
            mov si,floppy_boot_msg          ; move floppy_boot_msg  to si
            jmp .finish                     ; jump to finish and skip following code

    .exit_with_error:
            jmp hang

    .finish:
            call bios_print                 ; Call bios_print to print the message stored in si
            popa                            ; pop all general purpose registers back from the stack and restore them
            ret                             ; Set PC register to return address after poping it from the stack
