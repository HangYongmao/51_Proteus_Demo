;本程序为双极性四相六线步进电机连续控制程序,采用四相四步控制
;P2.0接PWM，低电平时电机停止工作，高电平时电机工作
;P2.1接L298的第一通道正反控制端
;P2.2接L298的第二通道正反控制端
;P2.3接供电电源控制端，低电平供电，高电平断电
;信号工作顺序：1低2低，1高2低，1高2高，1低2高
;电机正转工作顺序：A+B-C+D-,A-B+C+D-,A-B+C-D+,A+B-C-D+
;电机反向工作顺序：A+B-C-D+,A-B+C-D+,A-B+C+D-,A+B-C+D-
ORG 0000H
AJMP MAIN
ORG 0030H
MAIN:MOV R0,#25
ZHENG:MOV P2,#01H
     ACALL DELAY11
     MOV P2,#03H
     ACALL DELAY11
     MOV P2,#07H
     ACALL DELAY11
     MOV P2,#05H
     ACALL DELAY11
     DJNZ R0,ZHENG

FAN: MOV P2,#07H
     ACALL DELAY11
     MOV P2,#03H
     ACALL DELAY11
     MOV P2,#01H
     ACALL DELAY11
     MOV P2,#05H
     ACALL DELAY11
     INC R0
     MOV A,R0
     CJNE A,#26,FAN
     DEC R0
     AJMP MAIN

DELAY11:MOV  R7,#4
DELAY41:MOV  R6,#248
        DJNZ R6,$
        DJNZ R7,DELAY41
        RET
