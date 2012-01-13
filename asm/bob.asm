init:
    mov ax, 0x07C0  ; set up segments
    mov ds, ax
    mov es, ax

main:
    
    mov si, msg
    call write_string
    
    mov si, msg2
    call write_string_hex 
    
    mov si, newline
    call write_string

    .loop:
        ;mov si, prompt
        mov ah, 0
        int 0x16 ; al contains the key
        
        inc al; haha
        mov ah, 0x0e
        int 0x10 ; go ahead print it         
    jmp .loop

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
    ; 0-9 = 0x30 - 0x39
    ; A-F = 0x41 - 0x46
    ; Input: 0x0E (in al)
    ; Output: 0x3045 (big-endian to print)
    ; Get the first nybble, SHL it by 8
    ; If the first nybble is below 0x0A00
    ; add 0x2F00
    ; If it's not
    ; add 0x4000
    ; SHL 4
    ; Add the 2nd nybble
    ; If the 2nd nybble is below 0x0A
    ; add 0x2F
    ; if not
    ; add 0x40
    ; Ret

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

    msg db 'Welcome to DanOS!', 0x0a, 0x0d, 0
    msg2 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 0
    newline db 0x0a, 0x0d
    prompt db '>',0
 
    times 510-($-$$) db 0
    dw 0AA55h ; some BIOSes require this signature
