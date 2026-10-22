assume cs:code, ds:data

data segment
   db 'unIX'
   db 'foRK'
data ends

code segment
   start: mov al, 'a'
          mov bl, 'b'
          int 21h
code ends

end start
