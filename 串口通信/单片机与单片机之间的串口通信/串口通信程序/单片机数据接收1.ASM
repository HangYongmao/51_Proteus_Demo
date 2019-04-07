;接收程序奇偶判断有误
ORG 0000H
AJMP MAIN
ORG 0030H
MAIN:MOV SP,#5FH
     MOV SCON,#90H   ;设定串行口为工作方式2，并允许接收
     MOV PCON,#00H   ;波特率为fosc/64
     MOV R0,#30H     ;设置接收数据指针
     MOV R3,#10H     ;设置存放的数据块长度
LOOP:JBC RI,JSH      ;判断一帧数据是否接收完成
     AJMP LOOP
JSH: MOV A,SBUF      ;将接收数据送A中
     JB PSW.0,OTH    ;判断接收到的数据的奇偶性
     JB RB8,ERR      ;如果与发送的奇偶性不同，转错误处理
     AJMP RTH        ;转正确处理
OTH: ;JNB RB8,ERR
RTH: MOV @R0,A       ;接收数据送内部RAM
     INC R0
     DJNZ R3,LOOP    ;判断16个数是否接受完成
JS1: MOV R0,#30H     ;显示接受到的数据
JS3: MOV A,@R0
     MOV P0,A
     ACALL DELAY
     INC R0
     MOV A,R0
     CJNE A,#40H,JS2
     AJMP JS1
JS2: AJMP JS3
DELAY: MOV  R4,#04H
   D1: MOV  R7,#0FFH
   D2: MOV  R6,#0FFH
       DJNZ R6,$
       DJNZ R7,D2
       DJNZ R4,D1
       RET
ERR: END
