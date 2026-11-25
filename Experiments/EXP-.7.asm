
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


ORG 100H

; Add lower 16-bit words
MOV AX, [1100H]
ADD AX, [1104H]
MOV [1200H], AX

; Add higher 16-bit words with carry
MOV AX, [1102H]
ADC AX, [1106H]
MOV [1202H], AX

; Store final carry
MOV AL, 00H
JNC NO_CARRY
MOV AL, 01H

NO_CARRY:
MOV [1204H], AL

HLT


ret




