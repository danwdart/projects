    call init
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
init:
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
code:
    mov si, kernld
    call write_string   
    jmp load_kernel
    jmp $
 
vesa_get_info:
    mov ax, 0x4f00
    int 0x10
	; this should have set es:di to our point
    cmp ax, 0x4f00 ; did it work
    je .fail

    ;add di, 4 ; get to after the VESA signature
    ;mov ax, di
    ;mov si, ax
    mov si, di
    mov cx, 16
    call write_hexes
    jmp .end

.fail:
    mov ah, 0x0e
    mov al, "F"
    int 0x10
.end:

;cpuid:
;cpuid
;push ecx
;push edx
;push ebx
;mov cl, 12
;mov ah, 0x0e
;.start:
;pop al
;int 0x10
;cmp cl, 0
;je .end
;dec cl
;jmp .start
;.end: 



loop:
    jmp $


load_kernel:
    .reset:
        mov dl, 0x80 ; sda
        mov ah, 0
        int 0x13

    .read:
        mov ah, 0x02
        mov al, 19 ; sectors to read - todo confirm
        mov ch, 0 ; track
        mov cl, 3 ; sector
        mov dh, 0 ; head
        mov dl, 0x80 ; drive
        mov bx, 0x2000 ; segment ( * 0x10 )
        mov es, bx
        mov bx, 0x0000 ; offset (add to seg)
        int 0x13
        jnc .ok

        mov al, ah
        call write_hex
        cli
        hlt

    .ok:
        push es
        push bx
        retf ; ip=bx. cs = es	     

write_hexes:
    .start:
    lodsb
    call write_hex
    cmp cl, 0
    je .end
    dec cl
    jmp .start
    .end:
    ret

write_char:
    mov ah, 0x0e
    int 0x10
    ret

write_string_hex:
    .wsh:
    lodsb
    or al, al ; 0-terminated
    jz .endwsh
    call write_hex
    
    jmp .wsh

    .endwsh:
    ret

write_hex:
    .write:
    mov bl, al ; bl now 0x41 for example
    shr bl, 4 ; bl now 0x04

    and bl, 0x0f ; make sure!!!

    cmp bl, 0x0a
    jl .isless
    
    .isge:
    add bl, 0x37 ; for instance 0x0b + 0x37 = "B"
    jmp .cont

    .isless:
    add bl, 0x30 ; e.g. 0x04 + 0x30 = 0x34 = "4"
        jmp .cont

    .cont: 
    ; bl now correct
    ; bh can now be the higher byte
    mov bh, al ; bl now 0xba
    and bh, 0x0f ; bl now 0x0a

    cmp bh, 0x0a
    jl .islesst

    .isget:
    add bh, 0x37
    jmp .contt

    .islesst:
    add bh, 0x30
    jmp .contt

    .contt:
    ; bx now correct

    mov al, bl
    mov ah, 0x0e; print
    int 0x10

    mov al, bh
    int 0x10

    .end:
    ret

strcmp:
    .loop:
    mov al, [si] ; Move the value of the current source index into al
    mov bl, [di] ; move the value of the current dest index into bl
   
    cmp al, bl ; are they the same?

    jne .notequal
    ; so we're equal 
    
    cmp al, 0 ; is al 0 (we know bl is 0)
    je .done

    inc si
    inc di ; increment the index counters (so we can get the next bytes)
    jmp .loop

    .notequal:
            ; so we need somewhere to store our result,
            ; we could use anywhere but here an easy 1-bit ref will do 
        clc ; CLear Carry
        ret

    .done:
        stc ; SeT Carry
        ret

get_string:
    xor cl, cl ; blank count
    mov di, cmd_buffer

    .getchar:

    mov ah, 0
    int 0x16 ; al contains the key

    cmp al, 0x0d
    je .enter

    stosb
    ; Don't inc di here - it does it - and if you do, you could end up with 0x41 0x00 0x42
    ; - and the comparison would end at 0x00 of course

    ; echo it
    mov ah, 0x0e
    int 0x10

    jmp .getchar

    .enter:
    ; store a 0
    mov al, 0
    stosb
    inc di

    ; do the newline
    mov si, newline
    call write_string
    
    ; reset di
    mov di, cmd_buffer
    ret

write_string:
    .writechar:
    lodsb ; load [si] into al
    mov ah, 0x0E ; write function
    int 0x10
    or al, al
    jz .done

    jmp .writechar
    .done:
     ret

kernld db 'Finding kernel.bin', 0x13, 0x10, 0
newline db 0x0a, 0x0d, 0
prompt db '>',0
cmd_buffer times 64 db 0 

bootlabel:
    times 510-($-$$) db 0
    dw 0AA55h ; bootsector

; pad the rest with zeroes
times 1048576-($-$$) db 0
