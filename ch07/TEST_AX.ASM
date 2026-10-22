assume cs:codesg, ds:datasg

datasg segment
    db 12h, 34h, 56h, 78h
datasg ends

codesg segment

start:
    mov ax, datasg
    mov ds, ax

    mov ax, 0
    mov bl, [ax]

    mov ax, 4c00h
    int 21h

codesg ends

end start