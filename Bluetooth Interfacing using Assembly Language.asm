ORG 00H
CLR P2.5 ; LED connected
SETB P2.4 ; as buzzer connected
 
; for Bluetooth module
MOV TMOD,#20H ; timer 1 mode 2 is selected
MOV TH1,#0FDH ; baud rate
MOV SCON,#50H ; serial mode 1 10 bit total isn, 8db, 1STOPb
CLR TI ; making TI reg zero
SETB TR1 ; starting timer 1


;------------DISPLAY INITIALIZATION----------        	
	MOV DPTR,#MYLCD    ;DPTR stores the LCD initialization sequence
CIU1:   CLR A
    	MOVC A,@A+DPTR
    	LCALL COMNWRT
    	LCALL DELAY
    	JZ SIU1           ;Runs the rest of the code
    	INC DPTR
    	SJMP CIU1   	
   	
SIU1:   MOV DPTR,#MSG1      
DIU1:   CLR A
 	MOVC  A,@A+DPTR
  	LCALL DATAWRT
   	LCALL DOT 
    	JZ SIU2           ;Runs rest of the code
     	INC DPTR
      	SJMP DIU1
SIU2:	MOV A, #01    ;Clear LCD
	ACALL COMNWRT ;Call command subroutine
	ACALL DELAY   ;Give LCD some time
	LCALL DATAWRT
	MOV DPTR,#MSG2
DIU2:	CLR A
 	MOVC  A,@A+DPTR
  	LCALL DATAWRT
   	LCALL DOT 
    	JZ CONT1          ;Runs rest of the code
     	INC DPTR
      	SJMP DIU2
      	
CONT1: 
GOBACK:
CONT_RE:
CONT_M:
CONT_PRE: 
CLR RI ; register involved in receiving data from bluetooth and ensuring it
REP: JNB RI, REP
 
; preparing LCD
MOV DPTR,#MYLCD2    ;DPTR stores the LCD initialization sequence
CIIU1:  CLR A
    	MOVC A,@A+DPTR
    	LCALL COMNWRT
    	LCALL DELAY
    	JZ SIIU1           ;Runs the rest of the code
    	INC DPTR
    	SJMP CIIU1 
; writing the data from bluetooth
SIIU1: 
MOV A,SBUF  ; data from bluetooth stored in SBUF
ACALL DATAWRT  ; takes data from app and prints it in LCD
ACALL DELAY
 
CJNE A,#'X',CHECKN_PRE
CLR RI
GO_PRE:
CLR RI
MOV P2,#00000000B	
MOV P1,#00000000B
REP14: JNB RI,REP14
SJMP GO15
CHECKN_PRE: LJMP CHECKNEXT_PRE
GO15:
MOV A,SBUF
CJNE A,#'0',JA_PRE
MOV P2,#11111111B	
MOV P1,#11111111B
LJMP CONT_PRE
JA_PRE:

CJNE A,#'A',LED_B  
	MOV R1,#1
	LED_LOOP2: MOV R2,#2
	LED_LOOP1: MOV R3,#255
	LED_LOOP:
	CLR RI
	MOV P1,#01111110B 
      	MOV P2,#11111110B  
      	ACALL DELAY_LED        
      	MOV P1,#10001000B  
      	MOV P2,#11111101B  
      	ACALL DELAY_LED
      	MOV P1,#10001000B  
      	MOV P2,#11111011B  
      	ACALL DELAY_LED
      	MOV P1,#10001000B
      	MOV P2,#11110111B
      	ACALL DELAY_LED
      	MOV P1,#01111110B
      	MOV P2,#11101111B
      	ACALL DELAY_LED
	DJNZ R3,LED_LOOP
	DJNZ R2,LED_LOOP1
	DJNZ R1,LED_LOOP2
	
	LJMP GO_PRE
LJMP GO_PRE

LED_B:
CJNE A,#'B',GO_PRE
	MOV R1,#1 
	LED_LOOPB2: MOV R2,#3
	LED_LOOPB1: MOV R3,#255
	LED_LOOPB:
	MOV P1,#11111111B 
      	MOV P2,#11111110B  
      	ACALL DELAY_LED        
      	MOV P1,#10001001B  
      	MOV P2,#11111101B  
      	ACALL DELAY_LED
      	MOV P1,#10001001B  
      	MOV P2,#11111011B  
      	ACALL DELAY_LED
      	MOV P1,#01100110B
      	MOV P2,#11110111B
      	ACALL DELAY_LED
	DJNZ R3,LED_LOOPB
	DJNZ R2,LED_LOOPB1
	DJNZ R1,LED_LOOPB2
	
	LJMP GO_PRE
	
	
CHECKNEXT_PRE: 
CJNE A,#'y',CHEKK
CLR P3.5

 
CHEKK:
CJNE A,#'n',CHEKK1
SETB P3.5
 
CHEKK1:
CJNE A,#'l', CHECKNEXT
SETB P3.6
 
CHECKNEXT:
CJNE A,#'L', CHECKNEXT1
CLR P3.6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKNEXT1:
CJNE A,#'1', CHECKN_RE
CLR RI
GO_RE:
REP3: JNB RI,REP3
SJMP GO4
CHECKN_RE: LJMP CHECKNEXT_RE
GO4:

MOV A,SBUF
CJNE A,#'0',JA_RE
LJMP CONT_RE
JA_RE:  
ANL A, 0FH
MOV R2,A
RE_LOOP:
CLR P3.6
ACALL DELAY_RE
ACALL DELAY_RE
SETB P3.6
ACALL DELAY_RE
ACALL DELAY_RE
DJNZ R2, RE_LOOP
CLR RI 
LJMP GO_RE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKNEXT_RE:
CJNE A,#'M', CHECKN_M
CLR RI

GO_M:
CLR RI
REP4: JNB RI,REP4
SJMP GO5
CHECKN_M: LJMP CHECKNEXT_M
GO5:

MOV A,SBUF
CJNE A,#'0',JA_M
LJMP CONT_M
JA_M:

CJNE A,#'A',M_B  
CLR P3.5
CLR P3.6
ACALL DOT
SETB P3.5
SETB P3.6
ACALL DELAY_RE
CLR P3.5
CLR P3.6
ACALL DASH
ACALL DASH
SETB P3.5
SETB P3.6
ACALL DELAY
CLR RI
LJMP GO_M

M_B: 
CJNE A,#'B',GO_M
CLR P3.5
CLR P3.6
ACALL DASH
SETB P3.5
SETB P3.6
ACALL DELAY_RE
CLR P3.5
CLR P3.6
ACALL DOT
SETB P3.5
SETB P3.6
ACALL DELAY_RE
CLR P3.5
CLR P3.6
ACALL DOT
SETB P3.5
SETB P3.6
ACALL DELAY
CLR RI
LJMP GO_M

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECKNEXT_M:
CJNE A,#'D',CHECKN2
CLR RI ; register involved in receiving data from bluetooth and ensuring it
REP1: JNB RI, REP1
SJMP GO2
CHECKN2: LJMP CHECKNEXT2
GO2:
GOGO:

REP2: JNB RI, REP2
; preparing LCD
MOV A,#38H ; creatiing 2 lines and 5*7 matrix
ACALL COMNWRT
ACALL DELAY
MOV A,#0EH ; display on, cursor blinking
ACALL COMNWRT
ACALL DELAY
MOV A,#01H ; clear display skin
ACALL COMNWRT
ACALL DELAY
MOV A,#06H ; cursor shift right
ACALL COMNWRT
ACALL DELAY
MOV A,#0CH ; display on, cursor off
ACALL COMNWRT
ACALL DELAY

; writing the data from bluetooth
 
MOV A,SBUF  ; data from bluetooth stored in SBUF
ADD A,#07H
CJNE A,#'7',JAWAD
LJMP CONT1
JAWAD:
ACALL DATAWRT  ; takes data from app and prints it in LCD
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY

CLR RI ; register involved in receiving data from bluetooth and ensuring it


LJMP GOGO

 
CHECKNEXT2:
CJNE A,#'C', GOBACK1
LJMP GO3
GOBACK1: LJMP GOBACK 

GO3:
MOV R1, #9

MOV R2, #39H


COUNT_LOOP:
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
 
MOV A,#38H
ACALL COMNWRT
ACALL DELAY
MOV A,#0EH
ACALL COMNWRT
ACALL DELAY
MOV A,#01H
ACALL COMNWRT
ACALL DELAY
MOV A,#06H
ACALL COMNWRT
ACALL DELAY
MOV A,#0CH
ACALL COMNWRT
ACALL DELAY
MOV A,R2
DEC R2 
ACALL DATAWRT
ACALL DELAY
DJNZ R1, COUNT_LOOP
 
CLR P3.5 ; Buzzer on
ACALL DELAY1
SETB P3.5 ; after a certain time, turn it off
 
ACALL GOBACK


 
AGAIN: SJMP AGAIN

 
; for reading and writing in LCD subroutine and delay subroutine
 
COMNWRT: ; for command writing
MOV P0,A
CLR P3.2  ; RS=0
CLR P3.3 ; RW=0
SETB P3.4 ; EN=1
ACALL DELAY
CLR P3.4 ; EN=0 (high to low operation)
RET
 
DATAWRT: ; for data writing
MOV P0,A
SETB P3.2 ; RS=1
CLR P3.3 ; RW=0
SETB P3.4 ; EN=1
ACALL DELAY
CLR P3.4 ; EN=0(high to low)
RET
 
DATAENC:
ANL A, #07H
MOV P0,A
SETB P3.2 ; RS=1
CLR P3.3 ; RW=0
SETB P3.4 ; EN=1
ACALL DELAY
CLR P3.4 ; EN=0(high to low)
RET


; Delay subroutines
DELAY:
   	MOV R3,#50
HERE2: MOV R4,#255
HERE: DJNZ R4, HERE
  	DJNZ R3,HERE2
RET

DOT:
   	MOV R2,#10
HERR_D1: MOV R5,#50
HERR_D2: MOV R6,#255
HERR_D3: DJNZ R6,HERR_D3
   	DJNZ R5,HERR_D2
   	DJNZ R2,HERR_D1
RET 

DASH:
   	MOV R2,#20
HERR_DD1: MOV R5,#50
HERR_DD2: MOV R6,#255
HERR_DD3: DJNZ R6,HERR_DD3
   	DJNZ R5,HERR_DD2
   	DJNZ R2,HERR_DD1
RET 
 
;for buzzer alarm
DELAY1:
   	MOV R2,#50
HERR1: MOV R5,#50
HERR2: MOV R6,#255
HERR3: DJNZ R6,HERR3
   	DJNZ R5,HERR2
   	DJNZ R2,HERR1
RET


DELAY_RE:
   	MOV R3,#255
HERRR2: MOV R4,#255
HERRRE: DJNZ R4, HERRRE
  	DJNZ R3,HERRR2
RET

DELAY_PRE:
   	MOV R2,#100
HERR1_PRE: MOV R5,#255
HERR2_PRE: MOV R6,#255
HERR3_PRE: DJNZ R6,HERR3_PRE
   	DJNZ R5,HERR2_PRE
   	DJNZ R2,HERR1_PRE
RET

DELAY_LED: 	
		MOV 	R6,#255D     ; 1ms delay subroutine
HERE_LED: 	DJNZ 	R6,HERE_LED
      	RET

ORG 300H
MSG1: DB " GROUP 2 ",0
MSG2: DB " PROJECT 2 ",0
MYLCD : DB 38H,0EH,01,06,86H,0 
MYLCD2 : DB 38H,0EH,01,06,0CH,0      	
END