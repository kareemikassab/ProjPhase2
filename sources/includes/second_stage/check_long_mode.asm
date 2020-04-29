        check_long_mode:
            pusha                           ;store all general puspose registors in the stack again
            call check_cpuid_support        ; call this label to check if the CPU supports cpuid
            call check_long_mode_with_cpuid ; call this label to check if it supports long mode  as well
            popa                            ;retreive all general pupose registers from the stack 
            ret                             ; return to the call 

        check_cpuid_support:
            pusha               ;store all general puspose registors in the stack again
            
                ; This function need to be written by you.
                pushfd                          ;store the eflags in the stack 
                pushfd                          ;store them again for comparison purposes
                pushfd                          ;store them again for storage purposes
                pop eax                         ;store the eflags in eax
                
                xor eax,0x0200000               ;this xor is used to flip bit 21, however this step could be neglected
                push eax                        ;store the xored value of eflags in the stack again
                popfd                           ;retreive them again from the stack
                pushfd                          ;store them again
                pop eax                         ;retreive the eflags into eax again 
                
                pop ecx                         ;retrieve the original eflags into ecx for comparison purposes
                ; Now if the modified bit 21 is written to the eflags then bit 21 in eax is different from that in eax
                xor eax,ecx                     ;xor the eax and ecx to check/see the converted 21st bit
                and eax,0x0200000               ;reset all bits except bit 21 
                cmp eax,0x0                     ;check the result of the and check if the bit 21 is zero or not
                jne .cpuid_supported            ;if not equal to zero then it supports cpuid
                mov si,cpuid_not_supported      ;otherwise it does not support cpuid
                call bios_print                 ;call this label to print the cpuid is not supported (stored in si)
                jmp hang                        ;hang the process
                
                .cpuid_supported:               ;label called to print cpuid is supported
                mov si,cpuid_supported          
                call bios_print                 ;print what is in the si (cpuid supported)
                popfd



            popa                ; retreive all general pupose registers from the stack 
            ret                 ; return to the call 
            
            
            

        check_long_mode_with_cpuid:
            pusha                                ;store all general puspose registors in the stack again
            
            
                ; This function need to be written by you.
                mov eax,0x80000000              ;function 8 milion to check the long mode in cpuid
                cpuid
                cmp eax,0x80000001              ;check if the largest function number is bigger than 8 mil and one then it is not supported
                jl .long_mode_not_supported     ;if so go to long mode not supported
                mov eax,0x80000001              ;otherwise get this function invoked
                cpuid
                and edx,0x20000000              ;reset all bits except bit 29 for long mode purposes
                cmp edx,0                       ;compare the result of the and with zero
                je .long_mode_not_supported     ;if the result is equal to zero then long mode is not supported
                mov si,long_mode_supported_msg  ;store the long mode supported message in si for printing
                call bios_print                 ;print what is in si
                
                jmp .exit_check_long_mode_with_cpuid    ;otherwise call long mode with cpuid
                .long_mode_not_supported:
                mov si,long_mode_not_supported_msg      ;store the long mode not supported message in si for printing
                call bios_print                          ;print what is in si
                jmp hang                                ;then hang the process
                
                .exit_check_long_mode_with_cpuid:

            popa                ; retreive all general pupose registers from the stack 
            ret                 ; return to the call 
            
