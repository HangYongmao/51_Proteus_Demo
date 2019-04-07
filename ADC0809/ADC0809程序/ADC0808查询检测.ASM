;占用单元R0,R1,A,DPTR,30H~37H
ORG 0000H
AJMP MAIN
ORG 0030H
MAIN: MOV R0,#30H    ;数据暂存区首地址
      MOV R1,#08H    ;8路计数初值
      MOV DPTR,#7FF8H;指向0808通道0
      MOV A,#00H     ;此指令可缺省
      MOVX @DPTR,A   ;启动A/D转换
L1:   JB P3.3,L1     ;查询INT1是否为0
      MOVX A,@DPTR   ;若INT1为0，者转换结束，读出数据
      MOV @R0,A      ;存数
      INC DPTR       ;更新通道
      INC R0         ;更新暂存单元
      MOVX @DPTR,A   ;再次启动A/D转换
      DJNZ R1,L1     ;判断8路查询是否完毕
      AJMP MAIN      ;跳回重新开始
      END
