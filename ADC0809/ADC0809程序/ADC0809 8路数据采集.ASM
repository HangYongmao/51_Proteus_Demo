;本程序用到单元(30H~34H,3DH,3EH)
;(30H~34H)用于存放显示数据，(30H~33H)用于存放测量数据，34H用于存放通道号
;R1用于存放0809检测出来的8个数据
;(3DH、3EH)用于存放0809检测出来数据计算结果
      ORG 0000H
      AJMP MAIN
      ORG 0013H
      AJMP INT1
      ORG 0030H
;======================================
;主程序
MAIN: MOV R0,#30H      ;存放数据首地址
      MOV R2,#0FH      ;计算数据存放单元个数
      CLR A
QING: MOV @R0,A        ;将数据存放单元清零
      INC R0
      DJNZ R2,QING
      MOV R4,#08H      ;8路计数初值
      MOV 34H,#00H     ;初始通道显示单元为1号通道
      SETB IT1         ;INT1置为边沿触发
      SETB EA          ;开中断
      SETB EX1         ;允许INT1中断
      MOV DPTR,#7FF8H  ;指向0809通道0
      MOV A,#00H       ;此指令可缺省
      MOVX @DPTR,A     ;启动A/D转换
HERE: ACALL JI_SUAN
      AJMP HERE        ;等待中断
;==========================================
;中断子程序
INT1: CLR EX1
      PUSH PSW         ;保护现场
      MOVX A,@DPTR     ;读A/D转换结果
      MOV R1,A         ;存数据
      INC DPTR         ;更新通道
      MOV A,34H
      INC A
      MOV 34H,A
      DJNZ R4,LOOP     ;巡回未完继续
      MOV R4,#08H      ;重新赋初值
      MOV DPTR,#7FF8H
LOOP:
      MOVX @DPTR,A     ;启动A/D转换
      POP PSW
      RETI             ;返回中断

;========================================
;数据计算
JI_SUAN:
      MOV A,R1
      MOV B,#20        ;基准电压为5伏，分辨率为5/256约为20毫伏
      MUL AB           ;显示数值单位为毫伏
      MOV R7,A         ;测量出来的数据乘20毫伏即为实际电压值，但还是十六进制
      MOV A,B          ;高位存放在R6里，低位存放在R7里
      MOV R6,A
      MOV R5,#16
;=========================================
;双字节十六进制转双字节BCD码
SBIN_SBCD:
      MOV 3DH,#00H     ;数据计算结果清零
      MOV 3EH,#00H
SBIN_SBCD1:
      MOV A,R7  ;R7左移一位并送回
      RLC A
      MOV R7,A
      MOV A,R6  ;R6左移一位并送回
      RLC A
      MOV R6,A
      MOV A,3DH
      ADDC A,3DH
      DA A       ;T_S乘2并调整后送回
      MOV 3DH,A
      MOV A,3EH
      ADDC A,3EH
      DA A       ;T_M乘2并调整后送回
      MOV 3EH,A
      DJNZ R5,SBIN_SBCD1 ;循环运行24次得到BCD码结果
;=====================================
;双字节BCD码制转4个单字节BCD码
SBCD_DBCD:
      MOV A,3DH
      MOV B,A
      ANL A,#0FH ;将T_S里面的数据存放寄存器B里后再进行与操作得到低四位
      MOV 30H,A  ;并存放到数码管显示的第一位地址40H里面
      MOV A,B
      SWAP A     ;从寄存器取回原来保存的数，再进行高低位互换
      ANL A,#0FH ;进行与操作后得到高四位
      MOV 31H,A  ;最后存放到数码管显示的第二位地址41H里面
      MOV A,3EH  ;同上
      MOV B,A
      ANL A,#0FH
      MOV 32H,A
      MOV A,B
      SWAP A
      ANL A,#0FH
      MOV 33H,A

;=======================================
;显示子程序

DIS:     MOV R5,#50      ;显示循环次数，即改变显示延时刷新时间
DIS1:    MOV R1,#30H      ;把显示数据第一位放在R0里
         MOV R2,#04H      ;把显示的位码放在R1里
         MOV R3,#05H      ;把显示的长度放在R2里
DIS2:    MOV A,@R1
         ANL A,#0FH       ;屏蔽显示数据的高四位
         MOV B,A
         MOV A,R2
         ANL A,#0FH       ;屏蔽位码的高四位
         SWAP A
         ORL A,B
         MOV P0,A         ;送总显示数据到P0显示
         LCALL DELY4ms    ;调用延时4ms
         INC R1           ;取下一个显示数据
         DEC R2
         DJNZ R3,DIS2     ;四位显示晚后重新开始显示
         DJNZ R5,DIS1
         MOV A,34H        ;显示完后判断通道好是否为8
         CJNE A,#08H,HUI
         MOV 34H,#00H
HUI:     SETB EX1         ;显示完毕再允许中断
         RET
;=====================================
;延时子程序
DELY4ms: MOV R6,#8         ;延时4毫秒
D1:      MOV R7,#248
         DJNZ R7,$
         DJNZ R6,D1
         RET
         END
