%define MEM_REGIONS_SEGMENT         0x2000
%define PTR_MEM_REGIONS_COUNT       0x1000
%define PTR_MEM_REGIONS_TABLE       0x1018
%define MEM_MAGIC_NUMBER            0x0534D4150                
    memory_scanner:
            pusha                                       ;store all general purpose registers in the stack
            
            ; This function need to be written by you.
            pusha                       ;store all general purpose registers in the stack
            mov ax,MEM_REGIONS_SEGMENT  ;get the segment 2000 in ax
            mov es,ax                   ;get the copy in es
            xor ebx,ebx                 ;reset ebx to zero
            mov [es:PTR_MEM_REGIONS_COUNT],word 0x0         ;get the word at the es:2000 as a counter and initialize it with zero
            mov di, PTR_MEM_REGIONS_TABLE                   ;let di point to address 18 and make it 24 byte word aligned
            
            .memory_scanner_loop:                           
            mov edx,MEM_MAGIC_NUMBER            ;makeing dx set to the magic number SMAP
            mov word [es:di+20], 0x1            ;preparation for function e820 and interrupt 15
            mov eax, 0xE820                     ;move the function numner into eax
            mov ecx,0x18                        ;ecx has the memory size to be surfed through
            int 0x15                            ;inititate interrupt 15
            
            jc .memory_scan_failed              ;check carry falg, if set then then the memory scanning has failed
            cmp eax,MEM_MAGIC_NUMBER            ;compare the eax with the magic number
            jnz .memory_scan_failed             ;if not equal to zero then the memory scan has failed
            add di,0x18                         ;increment the di pointer by 28 bytes to move on with the next partition of the memory
            inc word [es:PTR_MEM_REGIONS_COUNT] ;increment the counter of memoery region
            cmp ebx,0x0                         ;compare ebx with zero
            jne .memory_scanner_loop            ;if not equal then loop again over the memory scanner
            jmp .finish_memory_scan             ;else memory scan has finished
            
            .memory_scan_failed:
            
            
            .finish_memory_scan:

            popa                                ;restore the general purpose registors from the stack
            ret                                 ;return to the original call

    print_memory_regions:
            pusha
            mov ax,MEM_REGIONS_SEGMENT                  
            mov es,ax       
            xor edi,edi
            mov di,word [es:PTR_MEM_REGIONS_COUNT]
            call bios_print_hexa
            mov si,newline
            call bios_print
            mov ecx,[es:PTR_MEM_REGIONS_COUNT]
            mov si,0x1018 
            .print_memory_regions_loop:
                mov edi,dword [es:si+4]
                call bios_print_hexa_with_prefix
                mov edi,dword [es:si]
                call bios_print_hexa
                push si
                mov si,double_space
                call bios_print
                pop si

                mov edi,dword [es:si+12]
                call bios_print_hexa_with_prefix
                mov edi,dword [es:si+8]
                call bios_print_hexa

                push si
                mov si,double_space
                call bios_print
                pop si

                mov edi,dword [es:si+16]
                call bios_print_hexa_with_prefix


                push si
                mov si,newline
                call bios_print
                pop si
                add si,0x18

                dec ecx
                cmp ecx,0x0
                jne .print_memory_regions_loop
            popa
            ret
