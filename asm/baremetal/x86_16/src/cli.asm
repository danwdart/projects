init:
    mov ax, 0x07C0  ; set up segments
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov cs, ax
    mov fs, ax
    mov gs, ax
cli:
    .loop:
        mov si, prompt
        call write_string
        call get_cmd

        ;mov si, cmd_buffer
        ;call write_string
        ;mov si, newline
        ;call write_string

        mov si, hello_cmd
        call strcmp
        je .hello

        mov si, arg_cmd
        call strcmp
        je .arg

        jmp .loop

        .hello:
            mov si, hello_msg
            call write_string
            jmp .loop

        .arg:
            mov al, ch
            call write_decimal
            jmp .loop

get_cmd:
    mov di, cmd_buffer
    .getchar:
    xor cx, cx ; blank counts
    call get_char

    cmp al, 0x0d
    je .enter

    cmp al, 0x08
    je .backspace

    cmp al, 0x20
    je .space

    .continue:
    stosb
    call write_char

    jmp .getchar

    .enter:
        mov al, 0
        stosb

        mov si, newline
        call write_string

        mov di, cmd_buffer
        ret

    .backspace:
        mov si, back_chars
        call write_string
        dec di
        jmp .getchar

    .space:
        ;push di
        mov al, 0
        stosb
        inc ch
        jmp .continue

get_char:
    mov ah, 0
    int 0x16 ; al contains the key
    ret

write_char:
    mov ah, 0x0e
    int 0x10
    ret

write_string:
    .writechar:
    lodsb ; load [si] into al

    or al, al
    jz .done

    call write_char

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
    .write:
    mov bl, al ; bl now 0x41 for example
    shr bl, 4 ; bl now 0x04

    and bl, 0x0f ; make sure!!!

    cmp bl, 0x0a
    add bl, 0x30
    jl .isless
    add bl, 0x07
    .isless:
    mov bh, al ; bl now 0xba
    and bh, 0x0f ; bl now 0x0a

    cmp bh, 0x0a
    add bh, 0x30
    jl .islesst
    add bh, 0x07
    .islesst:
    ; bx now correct
    mov al, bl

    call write_char

    mov al, bh
    call write_char

    .end:
    ret

write_decimal:
    ; e.g. 255 / 100
    ; al = 2, ah = 55
    ; if al > 0
    ; print al
    ; mov al, ah
    ; al = 55, ah = 5
    ; div by 10
    ; al = 5, ah = 5
    ; if al > 0
    ; print al
    ; print ah

    pusha
    mov ah, 0 ; use only al

    mov bl, 100
    div bl
    cmp al, 0
    jle .skipone
        add al, 0x30 ;"0"
        call write_char
        sub al, 0x30
    .skipone:

    mov al, ah

    mov bl, 100
    div bl
    cmp al, 0
    jle .skiptwo
        add al, 0x30
        call write_char
        sub al, 0x30
    .skiptwo:

    mov al, ah
    add al, 0x30
    call write_char
    sub al, 0x30

    popa
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
        clc ; CLear Carry
        ret

    .done:
        stc ; SeT Carry
        ret

data:
    hello_cmd db "hi", 0
    arg_cmd db "args", 0
    hello_msg db "Salutations!",0x0d, 0x0a, 0
    back_chars db 0x08, 0x20, 0x08, 0
    newline db 0x0d, 0x0a, 0
    prompt db 'MBR> ',0
    cmd_buffer times 64 db 0

times 510-($-$$) db 0
dw 0AA55h ; bootsector - some BIOSes require this signature
