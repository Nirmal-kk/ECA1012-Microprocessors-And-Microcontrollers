ORG 1000H

; ==========================================
; PROGRAM A - MAIN PROGRAM
; Install INT 40H vector and call the ISR
; ==========================================

MOV AX,0000H
MOV DS,AX
MOV ES,AX

; Store ISR offset and segment in IVT
MOV WORD PTR ES:[0100H],1100H
MOV WORD PTR ES:[0102H],0000H

; Initialise stack
MOV SP,0FFEH

; Store input array
MOV BYTE PTR [2800H],12H
MOV BYTE PTR [2801H],34H
MOV BYTE PTR [2802H],56H
MOV BYTE PTR [2803H],78H
MOV BYTE PTR [2804H],9AH

STI

; Pass parameters to ISR
MOV SI,2800H
MOV CX,0005H

; Invoke software interrupt
INT 40H

; Store returned sum
MOV [2810H],AX

; Store flags after IRET
PUSHF
POP WORD PTR [2814H]

HLT


; ==========================================
; PROGRAM A - INTERRUPT SERVICE ROUTINE
; Address: 1100H
; Sum N bytes from memory
; ==========================================

ORG 1100H

ISR_A:
PUSH BX
PUSH CX
PUSH SI

; Store flags inside ISR
PUSHF
POP WORD PTR [2812H]

; Clear accumulator
MOV AX,0000H
MOV BH,00H

NEXT_A:
MOV BL,[SI]
ADD AX,BX
INC SI
LOOP NEXT_A

; Restore registers
POP SI
POP CX
POP BX

IRET


; ==========================================
; PROGRAM B - MAIN PROGRAM
; Configure 8255 and wait for four NMIs
; ==========================================

ORG 1200H

MOV AX,0000H
MOV DS,AX
MOV ES,AX

; Install NMI vector (interrupt type 2)
MOV WORD PTR ES:[0008H],1300H
MOV WORD PTR ES:[000AH],0000H

; Initialise stack
MOV SP,0FFEH

; Configure 8255 Port A as input
MOV AL,90H
MOV DX,0FF56H
OUT DX,AL

; Clear event counter
MOV BYTE PTR [2900H],00H

WAIT1:
CMP BYTE PTR [2900H],04H
JB WAIT1

HLT


; ==========================================
; PROGRAM B - NMI SERVICE ROUTINE
; Address: 1300H
; Read Port A and store input in buffer
; ==========================================

ORG 1300H

ISR_B:
PUSH AX
PUSH BX
PUSH DX

; Read 8255 Port A
MOV DX,0FF50H
IN AL,DX

; Get current buffer index
MOV BL,[2900H]
MOV BH,00H

; Store input byte in buffer
MOV [BX+2901H],AL

; Increment event count
INC BYTE PTR [2900H]

; Restore registers
POP DX
POP BX
POP AX

IRET