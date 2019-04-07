;占用单元A,R0,R1,R2,R6,R7,30H,31H,32H,33H,34H
;入口30H,31H,32H,33H,34H即显示数据存放单元
          ORG 0000H
          LJMP MAIN
          ORG 0030H
MAIN:     MOV 30H,#01H     ;30H到34H单元里存放的是显示数据
          MOV 31H,#02H     ;30H存放的为最高位
          MOV 32H,#03H     ;34H存放的为最低位
          MOV 33H,#04H
          MOV 34H,#05H
          MOV P0,#8FH      ;关闭显示
DIS1:     MOV R0,#30H      ;把显示数据第一位放在R0里
          MOV R1,#00H      ;把显示的位码放在R1里
          MOV R2,#05H      ;把显示的长度放在R2里
DIS2:     MOV A,@R0
          ANL A,#0FH       ;屏蔽显示数据的高四位
          MOV B,A
          MOV A,R1
          ANL A,#0FH       ;屏蔽位码的高四位
          SWAP A
          ORL A,B
          MOV P0,A         ;送总显示数据到P0显示
          LCALL DELY4ms    ;调用延时4ms
          INC R0           ;取下一个显示数据
          INC R1
          DJNZ R2,DIS2     ;四位显示晚后重新开始显示
          AJMP DIS1
DELY4ms: MOV R6,#8         ;延时4毫秒
D1:      MOV R7,#248
         DJNZ R7,$
         DJNZ R6,D1
         RET
         END
