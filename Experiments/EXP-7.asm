; ==========================================
; EXPERIMENT 7
; 8255 PPI INTERFACING
; ==========================================


; ==========================================
; PROGRAM A
; Read Port A and store in memory
; Start address: 1100H
; ==========================================

ORG 1100H

MOV SI,1500H

; Configure Port A as input
MOV AL,90H
MOV DX,0FF56H
OUT DX,AL

; Read DIP switch data
MOV DX,0FF50H
IN AL,DX

; Store data in memory
MOV [SI],AL

HLT


; ==========================================
; PROGRAM B
; Switch-to-LED transfer
; Start address: 1200H
; ==========================================

ORG 1200H

; Configure 8255
MOV AL,90H
MOV DX,0FF56H
OUT DX,AL

AGAIN:
; Read Port A
MOV DX,0FF50H
IN AL,DX

; Send data to Port B
MOV DX,0FF52H
OUT DX,AL

; Repeat continuously
JMP AGAIN


; ==========================================
; PROGRAM C
; LED blinking using BSR mode
; Start address: 1300H
; ==========================================

ORG 1300H

; Five blinks
MOV CX,0005H

BLINK:
; Set PC0
MOV AL,01H
MOV DX,0FF56H
OUT DX,AL

CALL DELAY

; Reset PC0
MOV AL,00H
OUT DX,AL

CALL DELAY

LOOP BLINK

HLT


; ==========================================
; DELAY SUBROUTINE
; ==========================================

DELAY:
PUSH CX

MOV CX,0FFFFH

DLY:
LOOP DLY

POP CX
RET