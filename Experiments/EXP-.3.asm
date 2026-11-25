ORG 100H

MOV CX, 0000H       ; Initialize carry counter

MOV AX, [1200H]     ; Load first 16-bit number
MOV BX, [1202H]     ; Load second 16-bit number

ADD AX, BX          ; Add both numbers

JNC NO_CARRY        ; Jump if no carry
INC CX              ; Increment carry counter

NO_CARRY:
MOV [1204H], AX     ; Store sum
MOV [1206H], CX     ; Store carry

HLT                 ; Stop execution
