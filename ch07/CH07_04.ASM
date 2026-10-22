; This is the refined version from CH07_03.EXE
; Since we introduce the form [bx + idata]

assume cs:codesg, ds:datasg

datasg segment
    db 'BaSiC'
    db 'MinIX'
datasg ends

codesg segment

    start:
    
    ; Set up the data segment register
    mov  ax      , datasg
    mov  ds      , ax

    ; bx is used to represent the current index
    ; cs is used as a counter for the loop
    mov  bx      , 0
    mov  cx      , 5
 s: 
    ; We first convert the first string 
    mov  al      , [bx]
    and  al      , 11011111b
    mov  [bx]    , al

    ; Then we convert the second string
    mov  al      , [5 + bx] ; This can alternatively be written as
                            ; [200 + bx], 200[bx], or [bx].200
    or   al      , 00100000b
    mov  [5 + bx], al
    inc  bx
    loop s0

codesg ends

end start