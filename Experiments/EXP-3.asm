ORG 1000H

; INITIALIZE DATA SEGMENT
MOV AX, 0000H
MOV DS, AX

; =================================
; PROGRAM A: 32-BIT ADDITION
; =================================

MOV SI, 2000H
MOV DI, 2004H
MOV BX, 2008H

; Add lower words
MOV AX, [SI]
ADD AX, [DI]
MOV [BX], AX

; Add upper words with carry
MOV AX, [SI+2]
ADC AX, [DI+2]
MOV [BX+2], AX

; Store final carry
MOV AX, 0000H
ADC AX, 0000H
MOV [BX+4], AX


; =================================
; PROGRAM B: SUM OF N WORDS
; =================================

MOV SI, 2100H
MOV CX, [SI]
ADD SI, 02H

MOV AX, 0000H
MOV DX, 0000H

SUM_LOOP:
    ADD AX, [SI]
    ADC DX, 0000H

    ADD SI, 02H
    LOOP SUM_LOOP

; Store 32-bit sum
MOV [2150H], AX
MOV [2152H], DX


; =================================
; PROGRAM C: 64-BIT ADDITION
; =================================

MOV SI, 2200H
MOV DI, 2210H
MOV BX, 2220H

MOV CX, 0008H
CLC

ADD_LOOP:
    MOV AL, [SI]
    ADC AL, [DI]
    MOV [BX], AL

    INC SI
    INC DI
    INC BX

    LOOP ADD_LOOP

; Store final carry
MOV AL, 00H
ADC AL, 00H
MOV [BX], AL


; =================================
; END PROGRAM
; =================================

HLT