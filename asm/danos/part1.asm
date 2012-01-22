    call code
    oem_id db 'DANOS0.1'
    bytes_per_sector dw 0x0200 ; 512
    sectors_per_cluster db 0x04
    reserved_sectors dw 0x0001
    num_fats db 0x02
    num_dir_entries dw 0x0200
    num_total_sectors dw 0x0800
    media_descriptor db 0xf8 ; HD
    sectors_per_fat dw 0x0002
    sectors_per_track dw 0x0020
    total_heads dw 0x0040
    num_hidden_sectors dd 0x00000000
    large_sector_count dd 0x00000000
    ; fat12
    drive_number db 0x80 ; useless!
    nt_flags db 0x00 ; reserved
    drive_signature db 0x29 ; or 0x28 - so NT recognises it
    volume_id dd 0x12345678
    volume_label db 'DANOS FILES'
    sys_id db 'FAT12   '
code:
    cli             ; Clear interrupts
    mov ax, 0
    mov ss, ax          ; Set stack segment and pointer
    mov sp, 0FFFFh
    sti             ; Restore interrupts
    cld            
    mov ax, 2000h           ; Set all segments to match where kernel is loaded
    mov ds, ax    
    mov es, ax    
    mov fs, ax    
    mov gs, ax

    mov si, kernld
    call os_write_string   
   
    jmp $
     
os_write_string:
    .writechar:
    lodsb ; load [si] into al
    mov ah, 0x0E ; write function
    int 0x10
    or al, al
    jz .done

    jmp .writechar
    .done:
     ret

partmsg db 'Finding kernel.bin', 0x13, 0x10, 0
    
bootlabel:
    times 510-($-$$) db 0
    dw 0AA55h ; bootsector

; pad the rest with zeroes
times 1048576-($-$$) db 0
