assume cs:codesg, ds:datasg

datasg segment
    db 'BaSiC'
    db 'MinIX'
datasg ends

codesg segment

    start:
    
    mov  ax  , datasg
    mov  ds  , ax
    mov  bx  , 0

    mov  cx  , 5
 s: mov  al  , [bx]
    and  al  , 11011111b
    mov  [bx], al
    inc  bx
    loop s

    mov  bx  , 5
    mov  bx  , 5
s0: mov  al  , [bx]
    or   al  , 00100000b
    mov  [bx], al
    inc  bx
    loop s0

codesg ends

end start