
ORG 100H

MOV AX, [1200H]    ; Load 16-bit data

NOT AX             ; Find one's complement
MOV [1202H], AX    ; Store one's complement

INC AX             ; Find two's complement
MOV [1204H], AX    ; Store two's complement

HLT
