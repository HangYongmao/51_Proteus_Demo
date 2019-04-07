;占用单元R0,R1,A,DPTR,30H~37H
ORG 0000H
AJMP MAIN
ORG 0013H
AJMP INT1
ORG 0030H
MAIN: MOV R0,#30H      ;数据暂存区首地址
      MOV R1,#08H      ;8路计数初值
      SETB IT1         ;INT1置为边沿触发
      SETB EA          ;开中断
      SETB EX1         ;允许INT1中断
      MOV DPTR,#7FF8H  ;指向0808通道0
      MOV A,#00H       ;此指令可缺省
      MOVX @DPTR,A     ;启动A/D转换
HERE: NOP
      AJMP HERE        ;等待中断

INT1: PUSH PSW
      MOVX A,@DPTR     ;读A/D转换结果
      MOV @R0,A        ;存数
      INC DPTR         ;更新通道
      INC R0           ;更新暂存单元
      DJNZ R1,HUI      ;巡回未完继续
      MOV R0,#30H      ;数据暂存区首地址
      MOV R1,#08H      ;8路计数初值
      MOV DPTR,#7FF8H  ;指向0808通道0
HUI:  MOVX @DPTR,A     ;再次启动A/D转换
      POP PSW
      RETI             ;返回中断
