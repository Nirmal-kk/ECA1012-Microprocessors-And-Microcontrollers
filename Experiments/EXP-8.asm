
ORG 100H

MOV AX, [1200H]    ; Load 16-bit data
AND AX, 0F0FH      ; Mask selected bits
MOV [1202H], AX    ; Store result

HLT
