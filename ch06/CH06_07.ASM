; this corresponds to task (7) of the lab in chapter 6

assume cs:code, ds:a

a segment

   dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh, 0ffh

a ends

b segment

   dw 0, 0, 0, 0, 0, 0, 0, 0

b ends

code segment

start:

   mov ax, a
   mov ds, ax ; a uses another segment

   mov ax, b
   mov ss, ax ; b is the stack segment
   mov sp, 0010H

   mov bx, 0  ; set up the counter variables
   mov cx, 8

   s: push [bx]
      add bx, 2
   loop s

   mov ax, 4c00h
   int 21h

code ends

end start
