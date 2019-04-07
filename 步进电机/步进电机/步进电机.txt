 ZHENG EQU 30H      
   FAN EQU 31H
    NO EQU 32H
    AS EQU 33H
    SS EQU 34H
       ORG 00H 
       AJMP MAIN
       ORG  03H
       AJMP SUB_INT0
       ORG  30H
MAIN:  MOV 10H,#01H
       MOV 11H,#03H
       MOV 12H,#02H
       MOV 13H,#06H
       MOV 14H,#04H
       MOV 15H,#0CH
       MOV 16H,#08H
       MOV 17H,#09H
       MOV 20H,#50
       MOV 21H,#25
       MOV 22H,#10
       MOV 23H,#05
       CLR ZHENG
       CLR FAN
       CLR NO
       CLR AS
       CLR SS
       MOV R1,#20H
       MOV A,@R1
       MOV R5,A
       MOV IE,#10000001B
       SETB IT0
       MOV R0,#0FH
LOOP:  JNB ZHENG,LP
       CALL GO
  LP:  JNB FAN,LOOP
       CALL BACK
       AJMP LOOP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(中断)
SUB_INT0:
SCAN:  MOV A,P0
       CPL A
       ANL A,#00011111B
       JNZ SCAN1
       AJMP SCAN
       
SCAN1: CALL DELAY1
       MOV A,P0
       CPL A
       ANL A,#00011111B
       JZ SCAN
       CALL RDKEY     
       RETI

RDKEY: MOV A,P0
       JNB ACC.0,STOP
       JNB ACC.2,REV
       JNB ACC.1,FOR
       JNB ACC.3,ADDSPEED
       JNB ACC.4,SUBSPEED
       
       
     

STOP:  SETB  NO
       RET

FOR:   SETB ZHENG
       RET

REV:   SETB FAN
       RET

ADDSPEED:SETB AS
         RET

SUBSPEED:SETB SS
         RET

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(正转)

GO:    CLR ZHENG
       CLR FAN
       CLR NO
       CLR AS
       CLR SS
       INC R0
       MOV A,R0
       CJNE A,#18H,GO2
       MOV R0,#10H
GO2:   MOV P2,@R0
       MOV A,@R1
       MOV R5,A 
       CALL DELAY
       JB NO,RETURN
       JB ZHENG,RETURN
       JB FAN,RETURN 
       JNB SS,GO3
       CALL JIAN
GO3:   JNB AS,GO4
       CALL JIA
GO4:   AJMP GO
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(反转)

BACK:  CLR ZHENG
       CLR FAN
       CLR NO 
       CLR AS
       CLR SS   
       DEC R0
       MOV A,R0
       CJNE A,#0EH,TT
       MOV R0,#17H
       SJMP BACK2
  TT:  CJNE A,#0FH,BACK2
       MOV R0,#17H
BACK2: MOV P2,@R0
       MOV A,@R1
       MOV R5,A
       CALL DELAY
       JB NO,RETURN
       JB ZHENG,RETURN
       JB FAN,RETURN 
       JNB AS,BACK3
       CALL JIA
BACK3: JNB SS,BACK4
       CALL JIAN
BACK4: AJMP BACK
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(加速)
JIA:   MOV A,R1
       CJNE A,#23H,JIA1
       RET
JIA1:  INC R1
       RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~(减速)
JIAN:  MOV A,R1
       CJNE A,#20H,JIAN1
       RET
JIAN1: DEC R1 
       RET

    
RETURN:RET



DELAY: 
  D1:  MOV R6,#50
  D2:  MOV R7,#150
  D3:  DJNZ R7,$
       DJNZ R6,D2 
       DJNZ R5,D1       
       RET 







DELAY1: MOV R6,#60
   D4:  MOV R7,#100
        DJNZ R7,$
        DJNZ R6,D4
        RET


END