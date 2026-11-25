
ORG 100H

MOV AX, [1200H]     ; Load first number
MOV BX, [1202H]     ; Load second number

MUL BX              ; Multiply AX by BX
                    ; Result stored in DX:AX

MOV [1204H], AX     ; Store lower 16 bits
MOV [1206H], DX     ; Store higher 16 bits

HLT                 ; Stop execution
