assume cs:code, ds:c

a segment

   db 1, 2, 3, 4, 5, 6, 7, 8

a ends

b segment

   db 1, 2, 3, 4, 5, 6, 7, 8

b ends

c segment

   db 0, 0, 0, 0, 0, 0, 0, 0

c ends

code segment

start:

   mov cx, 8 ; we will loop for 8 times
   mov bx, 0 ; the current index
   mov dx, c ; stores the c segment
   mov ds, dx
   
   s: mov dx, a
      mov es, dx
      mov al, es:[bx]

      mov dx, b
      mov es, dx
      add al, es:[bx]

      mov [bx], al
      add bx, 1
   
   loop s

   mov ax, 4c00h
   int 21h

code ends

end start
