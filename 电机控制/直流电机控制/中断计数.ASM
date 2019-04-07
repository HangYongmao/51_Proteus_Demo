JI_SHU1   DATA   42H     ;中断计数值低位存放单元
JI_SHU2   DATA   43H     ;中断计数值高位存放单元
TIMER     DATA   44H     ;定时循环次数存放单元
ORG 0000H
AJMP MAIN
ORG 0013H
AJMP INT1
ORG 001BH
AJMP TIMER1
ORG 0030H
MAIN: MOV SP,#60H
      MOV JI_SHU1,#00H   ;计数单元清零
      MOV JI_SHU2,#00H
      MOV TIMER,#20      ;置定时循环次数20次
      MOV TMOD,#10H      ;置定时器1为定时工作方式1
      MOV TH1,#3CH       ;置定时初值，定时时间为50ms
      MOV TL1,#0B0H
      SETB IT1           ;置中断1为边沿触发方式
      SETB ET1           ;开定时开中断
      SETB EA
      SETB EX1
      SETB TR1
LOOP: AJMP LOOP          ;等待中断
INT1: PUSH PSW
      INC JI_SHU1        ;中断计数值低位加1
      MOV A,JI_SHU1
      CJNE A,#00,INT11   ;判断是否溢出
      INC JI_SHU2        ;中断计数值高位加1
INT11:POP PSW            ;中断返回
      RETI      
TIMER1:CLR TR1           ;关定时器1
       MOV TH1,#3CH      ;重新赋定时器1的初值
       MOV TL1,#0B0H
       DJNZ TIMER,TIMER11;判断定时时间1秒是否已到
       CLR EX1           ;关中断1，停止计数
       ;调用相关的子程序
       MOV TIMER,#20     ;重赋定时循环次数
       MOV JI_SHU1,#00H  ;中断计数单元情零
       MOV JI_SHU2,#00H
       SETB EX1         ;重新开中断1
TIMER11:SETB TR1         ;重新开定时器1
        RETI      
