assume cs:codesg, ss:stacksg, ds:datasg

; The stack is reversed to temporarily store 
; the current status of the counter of the outer loop.
; When we exit from the inner loop, that state is recovered.

stacksg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stacksg ends

datasg segment
    db '1. display      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify       '
datasg ends

codesg segment
    start:  ;===== Initial Setup =====
            ;===== Init 1: Stack =====
            mov ax, stacksg
            mov ss, ax
            mov sp, 16

            ;===== Init 2: Data Segment =====
            mov ax, datasg
            mov ds, ax

            ;===== Init 3: Address of the current row =====
            mov bx, 0

            mov cx, 4
        s0: push cx

            mov si, 0
            mov cx, 4
         s: mov al, [bx + 3 + si]
            and al, 11011111b
            mov [bx + 3 + si], al
            inc si
            loop s
            
            add bx, 16
            pop cx
            loop s0

            mov ax, 4c00H 
            int 21H
     
codesg ends

end start