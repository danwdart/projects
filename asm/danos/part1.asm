    call init
    OEMId db 'DANOS0.1'
    BytesPerSector dw 512
    SectorsPerCluster db 1
    ReservedForBoot dw 1
    NumberOfFats db 2
    NumberOfDirEntries dw 512 ; sectors to read = direntries * 32 / (bytespercluster*sectorspercluster) = 32
    LogicalSectors dw 2047 ;= 1M. 0x0800
    MediaDescriptor db 0xf8 ; f8 = HD
    SectorsPerFat dw 9 ;2
    SectorsPerTrack dw 18 ;32
    TotalHeads dw 2 ; 0x0040
    HiddenSectors dd 0
    LargeSectors dd 0
    ; fat12
    DriveNumber db 0x80 ; useless!
    NTFlags db 0x00 ; reserved
    DriveSignature db 0x29 ; or 0x28 - so NT recognises it
    VolumeId dd 0x78563412
    VolumeLabel db 'DANOS FILES'
    SysId db 'FAT12   '
init:
    cli             ; Clear interrupts
    mov ax, 0
    mov ss, ax          ; Set stack segment and pointer
    mov sp, 0FFFFh
    sti             ; Restore interrupts
    cld            
    mov ax, 2000h           ; Set all segments to match where booter is loaded
    mov ds, ax    
    mov es, ax    
    mov fs, ax    
    mov gs, ax
code:
    mov si, kernld
    call write_string   
    jmp load_kernel
    jmp $

load_kernel:
    .reset:
        mov dl, 0x80 ; sda
        mov ah, 0
        int 0x13

    .read:
        mov ah, 0x02
        mov al, 19 ; sectors to read = reserved + fats * sectors per fat
        mov ch, 0 ; track
        mov cl, 3 ; sector, 1-based
        mov dh, 0 ; head
        mov dl, 0x80 ; drive
        mov bx, 0x3000 ; segment to load it to
        mov es, bx
        mov bx, 0x0000 ; offset (add to seg)
        int 0x13
        jnc .ok
    
    .error:
        mov al, ah
        call write_hex
        cli
        hlt
        jmp $

    .ok:
    mov bx, 0x3000
    mov ds, bx ; here is the data segment
    mov cx, 0x2500 ; bigger than this 
    mov si, filename
    mov bx, 12
    mov di, 0
    clc
    call findstr_in_junk
    jc .found
    .notfound:
        mov ah, 0x0e
        mov al, "N"
        int 0x10
        hlt
    .found:
    ; echo first letter of the count

    mov si, dx
    mov cx, 0x2500
    call write_hexes
    hlt

jmp $ 

write_hexes:
    .start:
    lodsb
    call write_hex
    cmp cx, 0
    je .end
    dec cx
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

findstr_in_junk:
    ; 1. si = ^HELLO
    ; 2. di = ^\0\0\0\0\0\0HELLO\0\0\0\0\0
    ; 3. bx = string length
    ; 3. cx = when to give up
    ; CACHE bx in dx
    ; CACHE si in ax
    ; loop:
    ; if bx = 0 then return success
    ; if cx = 0 then return fail
    ; cmp [si], [di]
    ; if so inc si, inc di, dec bx 
    ; if not, inc di, reset si, reset bx
    ; regardless decrement dx
    ; jmp loop
    ; return value: dx
    mov dx, bx
    mov ax, si
    .loop:
    cmp bx, 0
    jz .success
    cmp cx, 0
    jz .fail
    cmpsb
    je .ok
    .notok:
    mov si, ax
    mov bx, dx
    jmp .cont
    .ok:
    ;inc si
    ;inc di
    dec bx
    ;jmp .cont
    .cont:
    dec dx
    jmp .loop
    .success:
    stc
    mov dx, di
    ret
    .fail:
    clc
    mov dx, 0
    ret

findstr:
    ; 1. si = ^HELLO
    ; 2. di = ^ASTRINGHELLOASTRING
    ; cmp [si], [di]
    ; if [si] = 0 then return carry decrement di
    ; if cx = 0 then return nocarry
    ; if same, increment both
    ; 1. si = H^ELLO
    ; if different, increment di, reset si
    ; regardless decrement cx
    ; go to 3

    .loop:
    mov al, [si] ; lodsb would work just as well I suppose
    mov dx, si ; save location
    mov bl, [di]
    cmp al, 0
    je .success
    cmp cx, 0
    je .fail
    cmp al, bl
    jne .different
    .same:
    inc si
    inc di
    jmp .finish
    .different:
    inc di
    mov si, dx
    jmp .finish
    .finish:
    dec cx
    jmp .loop
    .success:
    dec di
    stc
    mov dx, di ; I just added this for good measure
    ret
    .fail:
    clc
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

kernld db 'Finding kernel.bin', 0x0d, 0x0a, 0
filename db 'KERNEL  BIN',0
newline db 0x0a, 0x0d, 0
prompt db '>',0
cmd_buffer times 64 db 0 

bootlabel:
    times 510-($-$$) db 0
    dw 0AA55h ; bootsector
buffer:
; pad the rest with zeroes
times 1048576-($-$$) db 0
