init:
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax

vesa_get_info:
    mov ax, 0x4f00
    int 0x10
	; this should have set es:di to our point
    cmp ax, 0x4f00 ; did it work
    je .fail

    ; it looks like this:
    ; dd sig
    ; dw version
    ; oemstring ptr dw dw
    ; caps dd
    ; We want this! modes dw dw
    ; dw mem

    ;add di, 4 ; get to after the VESA signature
    ;mov ax, di
    ;mov si, ax
    add di, 14
    mov si, vesa3
    cmpsw
    jne .notthree
    mov ah, 0x0e
    mov al, "Y"
    int 0x10
    jmp .end

    .notthree:
        mov ah, 0x0e
        mov al, "N"
        int 0x10
        jmp .end
    jmp .end
.fail:
    mov ah, 0x0e
    mov al, "F"
    int 0x10
.end:
    vesa3 dw 0x0200
times 510-($-$$) db 0
dw 0xaa55
