
.MODEL SMALL
.STACK 100H

.DATA

PBIMG   DB 00H
RUN     DB 00H
LEDCNT  DB 50
SECCNT  DB 100
SECS    DB 00H
MINS    DB 00H
UPDATE  DB 00H
RAMP    DB 00H
DACVAL  DB 00H

MSG     DB 'BATCH: 0125',0
SEG125  DB 00H,00H,00H,06H,5BH,6DH

.CODE

MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    CALL INIT_8255
    CALL LCD_INIT
    CALL INIT_8253
    CALL INIT_8251
    CALL INIT_8279

    CALL SHOW_BATCH
    CALL SHOW_125

    MOV AH,4CH
    INT 21H
MAIN ENDP

; --------------------------------
; 8255 INITIALIZATION
; --------------------------------

INIT_8255 PROC
    MOV AL,98H
    OUT 83H,AL

    MOV AL,88H
    OUT 8BH,AL

    XOR AL,AL
    OUT 81H,AL
    OUT 89H,AL

    MOV PBIMG,AL
    RET
INIT_8255 ENDP

; --------------------------------
; LCD COMMAND
; AL = command
; --------------------------------

LCD_CMD PROC
    PUSH AX

    OUT 88H,AL

    MOV AL,00H
    OUT 8BH,AL

    MOV AL,02H
    OUT 8BH,AL

    MOV AL,05H
    OUT 8BH,AL

    CALL DLY_50US

    MOV AL,04H
    OUT 8BH,AL

    CALL DLY_2MS

    POP AX
    RET
LCD_CMD ENDP

; --------------------------------
; LCD DATA
; AL = ASCII character
; --------------------------------

LCD_DATA PROC
    PUSH AX

    OUT 88H,AL

    MOV AL,01H
    OUT 8BH,AL

    MOV AL,02H
    OUT 8BH,AL

    MOV AL,05H
    OUT 8BH,AL

    CALL DLY_50US

    MOV AL,04H
    OUT 8BH,AL

    CALL DLY_50US

    POP AX
    RET
LCD_DATA ENDP

; --------------------------------
; LCD INITIALIZATION
; --------------------------------

LCD_INIT PROC
    CALL DLY_20MS

    MOV AL,38H
    CALL LCD_CMD
    CALL LCD_CMD
    CALL LCD_CMD

    MOV AL,0CH
    CALL LCD_CMD

    MOV AL,06H
    CALL LCD_CMD

    MOV AL,01H
    CALL LCD_CMD

    RET
LCD_INIT ENDP

; --------------------------------
; DISPLAY BATCH MESSAGE
; --------------------------------

SHOW_BATCH PROC
    MOV AL,80H
    CALL LCD_CMD

    MOV SI,OFFSET MSG

NEXT_CHAR:
    MOV AL,[SI]
    CMP AL,00H
    JE BATCH_DONE

    CALL LCD_DATA
    INC SI
    JMP NEXT_CHAR

BATCH_DONE:
    RET
SHOW_BATCH ENDP

; --------------------------------
; 8253 INITIALIZATION
; --------------------------------

INIT_8253 PROC
    MOV AL,36H
    OUT 93H,AL

    MOV AL,0AH
    OUT 90H,AL

    MOV AL,00H
    OUT 90H,AL

    MOV AL,92H
    OUT 93H,AL

    MOV AL,0FAH
    OUT 92H,AL

    MOV AL,76H
    OUT 93H,AL

    MOV AL,00H
    OUT 91H,AL

    MOV AL,3CH
    OUT 91H,AL

    RET
INIT_8253 ENDP

; --------------------------------
; 8251 INITIALIZATION
; --------------------------------

INIT_8251 PROC
    XOR AL,AL

    OUT 0A1H,AL
    OUT 0A1H,AL
    OUT 0A1H,AL

    MOV AL,40H
    OUT 0A1H,AL

    MOV AL,7EH
    OUT 0A1H,AL

    MOV AL,37H
    OUT 0A1H,AL

    RET
INIT_8251 ENDP

; --------------------------------
; SEND CHARACTER
; AH = character
; --------------------------------

SEND_CHAR PROC

WAIT_TX:
    IN AL,0A1H
    TEST AL,01H
    JZ WAIT_TX

    MOV AL,AH
    OUT 0A0H,AL

    RET
SEND_CHAR ENDP

; --------------------------------
; 8279 INITIALIZATION
; --------------------------------

INIT_8279 PROC
    MOV AL,00H
    OUT 0B1H,AL

    MOV AL,2FH
    OUT 0B1H,AL

    MOV AL,0D1H
    OUT 0B1H,AL

WAIT_CLEAR:
    IN AL,0B1H
    TEST AL,80H
    JNZ WAIT_CLEAR

    RET
INIT_8279 ENDP

; --------------------------------
; READ KEYPAD
; Returns key code in AL
; --------------------------------

GETKEY PROC

WAIT_KEY:
    IN AL,0B1H
    AND AL,0FH
    JZ WAIT_KEY

    MOV AL,40H
    OUT 0B1H,AL

    IN AL,0B0H
    AND AL,3FH

    RET
GETKEY ENDP

; --------------------------------
; DISPLAY 125 ON 7-SEGMENT
; --------------------------------

SHOW_125 PROC
    MOV AL,90H
    OUT 0B1H,AL

    MOV SI,OFFSET SEG125
    MOV CX,6

DISPLAY_LOOP:
    MOV AL,[SI]
    OUT 0B0H,AL

    INC SI
    LOOP DISPLAY_LOOP

    RET
SHOW_125 ENDP

; --------------------------------
; READ ADC0808
; Returns ADC value in AL
; --------------------------------

READ_ADC PROC
    MOV AL,00H
    OUT 82H,AL

    MOV AL,08H
    OUT 82H,AL

    MOV AL,00H
    OUT 82H,AL

WAIT_EOC_LOW:
    IN AL,82H
    TEST AL,10H
    JNZ WAIT_EOC_LOW

WAIT_EOC_HIGH:
    IN AL,82H
    TEST AL,10H
    JZ WAIT_EOC_HIGH

    IN AL,80H

    RET
READ_ADC ENDP

; --------------------------------
; DAC RAMP
; --------------------------------

RAMP_STEP PROC
    MOV AL,DACVAL
    ADD AL,02H

    CMP AL,0C0H
    JB OUTPUT_DAC

    MOV AL,0C0H
    MOV RAMP,00H

OUTPUT_DAC:
    MOV DACVAL,AL
    OUT 81H,AL

    RET
RAMP_STEP ENDP

; --------------------------------
; DELAY ROUTINES
; --------------------------------

DLY_50US PROC
    MOV CX,15

D1:
    LOOP D1
    RET
DLY_50US ENDP

DLY_2MS PROC
    MOV CX,600

D2:
    LOOP D2
    RET
DLY_2MS ENDP

DLY_20MS PROC
    MOV CX,6000

D3:
    LOOP D3
    RET
DLY_20MS ENDP

END MAIN
