
ORG 100H

MOV AX, [1200H]    ; Load 16-bit data
OR AX, 0F0FH       ; Set selected bits
MOV [1202H], AX    ; Store result

HLT
