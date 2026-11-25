
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


ORG 100H

MOV DX, 0000H       ; Clear DX
MOV AX, [1200H]     ; Load dividend
MOV BX, [1202H]     ; Load divisor

DIV BX              ; Divide DX:AX by BX

MOV [1204H], AX     ; Store quotient
MOV [1206H], DX     ; Store remainder

HLT                 ; Stop execution


ret




