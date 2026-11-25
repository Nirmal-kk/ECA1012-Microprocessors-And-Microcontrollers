
ORG 100H

MOV CX, 0000H       ; Initialize borrow counter

MOV AX, [1300H]     ; Load first number
MOV BX, [1302H]     ; Load second number

SUB AX, BX          ; Subtract BX from AX

JNC NO_BORROW       ; Jump if no borrow
INC CX              ; Increment borrow counter

NO_BORROW:
MOV [1304H], AX     ; Store difference
MOV [1306H], CX     ; Store borrow

HLT                 ; Stop execution
