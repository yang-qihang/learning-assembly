assume cs:codesg

codesg segment
   
   mov ax, 0123h
   mov bx, 0456h
   add ax, bx
   add ax, ax

   mov ax, 4c00h  ; set the register AX to 4c00 as some kind of flag.
   int 21h        ; this line triggers the DOS interrupt.

codesg ends

end
