assume cs:codesg

data segment
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'
    ; The above are the 21 strings used to represent 21 years
    ; Each string is essentially 4 bytes (each digit requires one byte!)

    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
    ; The above are the 21 dword data points that represent that revenue of the comany
    ; over the last 21 years

    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800
    ; The above are the 21 data items that represent the total number of employees of the company
    ; during the 21 years
data ends

table segment
    ; For each row of the table, it occupies a total of 16 bytes (which is one paragraph)
    db 21 dup ('year summ ne ?? ')
table ends

codesg segment

    ; Some math involved in this program first:
    ; Let i denote the current year, i := 0..21
    ; --------------------------------------------------------------------------------------
    ;   year:     4i       | 4 bytes |  bx = 0, +4 [bx].0/2
    ;   revenue:  4i + 84  | 4 bytes |  84[bx].0/2
    ;   employee: 2i + 168 | 2 bytes |  168[si]
    ; --------------------------------------------------------------------------------------
    ; Table:
    ; --------------------------------------------------------------------------------------
    ;   row(i) = 16i
    ;      1. year:     16i + 0  ..= 16i + 1  es:[di].0 (word)
    ;                   16i + 2  ..= 16i + 3  es:[di].2 (word)
    ;      2. revenue:  16i + 5  ..= 16i + 6  es:[di].5 (word)
    ;                   16i + 7  ..= 16i + 8  es:[di].7
    ;      3. employee: 16i + 10 ..= 16i + 11 es:[di].10
    ;      4. avg rev:  16i + 13 ..= 16i + 14 es:[di].13
    ; --------------------------------------------------------------------------------------
    ; Register Assignement:
    ; --------------------------------------------------------------------------------------
    ;    ds: datasg
    ;    es: table
    ; --------------------------------------------------------------------------------------
    ;    ax: ad-hoc + division
    ;    dx: division
    ; --------------------------------------------------------------------------------------
    ;    cx: counter
    ; --------------------------------------------------------------------------------------
    ;    bx: year + revenue
    ;    si: employee
    ;    di: table
    ; --------------------------------------------------------------------------------------

    start:  mov ax, data
            mov ds, ax
            
            mov ax, table
            mov es, ax
            
            ; Setting up three counters
            mov bx, 0 ; +4
            mov si, 0 ; +2
            mov di, 0 ; +16
            ; Setting up loop counter: 21 times
            mov cx, 21
        s:  ; ----------------------------- 
            ; year
            ; -----------------------------
            ; 2 higher digits (one word)
            mov ax         ,  [bx].0
            mov es:[di].0  ,  ax
            ; 2 lower  digits (one word)
            mov ax         ,  [bx].2
            mov es:[di].2  ,  ax

            ; ----------------------------- 
            ; revenue
            ; -----------------------------
            ; 2 lower digits (one word)
            mov ax         ,  84[bx].0
            mov es:[di].5  ,  ax

            ; 2 higher digits (one word)
            mov dx         ,  84[bx].2
            mov es:[di].7  ,  dx
            
            ; ----------------------------- 
            ; the average salary
            ; -----------------------------
            div word ptr      168[si]
            mov es:[di].13 ,  ax

            ; ----------------------------- 
            ; the number of employers
            ; -----------------------------
            mov ax         ,  168[si]
            mov es:[di].10 ,  ax

            ; ----------------------------- 
            ; update the counters
            ; -----------------------------
            add bx, 4  ; double word
            add si, 2  ; word
            add di, 16 ; 10H
            loop s 
            
            mov ax, 4c00H
            int 21h

codesg ends

end start