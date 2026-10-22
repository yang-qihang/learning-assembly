assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
    db 'ibm             '
    db 'dec             '
    db 'dos             '
    db 'vax             '
datasg ends

stacksg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
stacksg ends

codesg segment
    start:  mov  ax, stacksg
            mov  ss, ax
            
            mov  sp, 16
            mov  ax, datasg

            mov  ds, ax
            mov  bx, 0

            ; ===== Outer Loop (part 1) =====
            ; The counter for the outer loop
            mov  cx, 4
       s0:  push cx
            mov  si, 0

            ; ===== Inner Loop =====
            ; The counter for the inner loop
            mov  cx, 3
        s:  mov  al, [bx + si]
            and  al, 1101111b
            mov  [bx + si], al
            inc si
            loop s

            ; ===== Outer Loop (part 2) =====
            add bx, 16
            ; pop the counter for the outer loop,
            ; which was temporarily cached during inner loop!
            pop cx
            loop s0
            
            mov ax, 4c00h
            int 21h

codesg ends
end start