assume cs:code

code segment

   mov ax, 0fffh
   mov ds, ax
   mov bx, 6

   mov al, [bx]
   mov ah, 0

   mov dx, 0

   mov cx, 123     ; please keep in mind that when there's no pre/su-ffix
                   ; indicating it's in hexdecimal, then it's in decimal!
 s:add dx, ax
   loop s

   mov ax, 4c00h
   int 21h

code ends

end
