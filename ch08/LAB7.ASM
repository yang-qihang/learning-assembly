; ============================================================
; 8086 Assembly Language - Lab 02
; ------------------------------------------------------------
; Title:      Annual Company Statistics
; Author:     Yang Qihang
; Student ID: 2025211681
; ------------------------------------------------------------
; Description:
;   Organize 21 years of company statistics into a table,
;   including year, revenue, employee count, and average
;   revenue per employee.
; ============================================================

assume cs:codesg

data segment
    ; 21 years, each represented by four ASCII bytes.
    db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
    db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
    db '1993', '1994', '1995'

    ; 21 annual revenues, each stored as a doubleword (4 bytes).
    dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
    dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000

    ; 21 employee counts, each stored as a word (2 bytes).
    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800 
data ends

table segment
    ; 21 records, each occupying 16 bytes (one paragraph).
    db 21 dup ('year summ ne ?? ')
table ends

codesg segment

    ; Memory Layout (i = 0..20):
    ; ============================================================
    ; Source (DS):
    ;   Year:       4i       | 4 bytes | [bx].0/2
    ;   Revenue:    4i + 84  | 4 bytes | 84[bx].0/2
    ;   Employees:  2i + 168 | 2 bytes | 168[si]
    ; ------------------------------------------------------------
    ; Destination (ES): Record i begins at offset 16i.
    ;   Year:       0..3     | 4 bytes | es:[di].0/2
    ;   Revenue:    5..8     | 4 bytes | es:[di].5/7
    ;   Employees: 10..11    | 2 bytes | es:[di].10
    ;   Average:   13..14    | 2 bytes | es:[di].13
    ; ============================================================

    ; Register Allocation:
    ; ============================================================
    ; DS / ES: Source / destination segments
    ; AX / DX: Temporary operands; DX:AX for 32-bit division
    ; CX:      Loop counter
    ; BX:      Year and revenue offset (+4)
    ; SI:      Employee offset (+2)
    ; DI:      Destination record offset (+16)
    ; ============================================================

    start:  mov ax, data
            mov ds, ax

            mov ax, table
            mov es, ax

            ; Initialize offsets and loop counter.
            mov bx, 0
            mov si, 0
            mov di, 0
            mov cx, 21

        s:  ; -----------------------------
            ; Year (4 ASCII bytes)
            ; -----------------------------
            mov ax         , [bx].0
            mov es:[di].0  , ax

            mov ax         , [bx].2
            mov es:[di].2  , ax

            ; -----------------------------
            ; Revenue (32-bit integer)
            ; -----------------------------
            mov ax         , [bx + 84].0
            mov es:[di].5  , ax

            mov dx         , [bx + 86].2
            mov es:[di].7  , dx

            ; -----------------------------
            ; Average revenue per employee
            ; -----------------------------
            ; DX:AX / employee count -> AX (quotient)
            div word ptr     168[si]
            mov es:[di].13 , ax

            ; -----------------------------
            ; Employee count (16-bit)
            ; -----------------------------
            mov ax         , 168[si]
            mov es:[di].10 , ax

            ; -----------------------------
            ; Advance to the next record
            ; -----------------------------
            add bx, 4
            add si, 2
            add di, 16
            loop s

            mov ax, 4c00h
            int 21h

codesg ends

end start
