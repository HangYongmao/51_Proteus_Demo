LEN  EQU  30H     ;高电平比例初值存放单元
GAO  DATA 31H     ;高电平存放单元
DI   DATA 32H     ;低电平存放单元
GORD BIT  20H     ;高电平或低电平位判断存放单元
ORG  0000H
AJMP MAIN
ORG  000BH
AJMP DVT0
ORG  0030H
MAIN:MOV LEN,#10
     SETB P2.0
     CLR P2.2
     SETB GORD    ;置高低电平判断位为1
     MOV GAO,LEN ;置高电平初值
     MOV A,#100   ;置周期总长值
     SUBB A,GAO   ;求低电平比例值
     MOV DI,A     ;存低电平比例值
     MOV TMOD,#01H;置定时器0为定时工作方式1
     MOV TH0,#0FEH;赋定时器初值
     MOV TL0,#0CH
     SETB ET0     ;开定时器0
     SETB EA
     SETB TR0
LOOP:AJMP LOOP    ;等待

DVT0:PUSH PSW     ;保护现场
     PUSH A
     MOV TH0,#0FEH;重新赋初值
     MOV TL0,#0CH
     MOV A,LEN
     CJNE A,#0,PD1  ;判断高电平比例初值是否为0
     CLR P2.1
     AJMP DVT2
PD1: CJNE A,#100,PD2;判断高电平比例初值是否为100
     SETB P2.1
     AJMP DVT2
PD2: JNB GORD,DVT1;判断高低电平位是否为0，为0转
     DJNZ GAO,DVT2;判断高电平是否已完
     CLR P2.1     ;置P2.1为低电平
     CLR GORD     ;置高低电平位为0
     MOV GAO,LEN ;
     MOV A,#100
     SUBB A,GAO
     MOV DI,A     ;求低电平比例值
     AJMP DVT2
DVT1:DJNZ DI,DVT2 ;判断低电平是否已完
     SETB P2.1    ;置P2.1为高电平
     SETB GORD    ;置高低电平位为1
     MOV GAO,LEN
DVT2:POP A        ;恢复现场
     POP PSW
     RETI         ;返回中断
